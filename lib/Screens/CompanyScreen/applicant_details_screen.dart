import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Controller/image_uplode_controller.dart';
import 'package:jop_project/Models/job_advertisement_model.dart';
import 'package:jop_project/Models/orders_model.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Screens/ChatScreen/chat_screen.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicantDetailsScreen extends StatelessWidget {
  final SearchersModel searcher;
  final JobAdvertisementModel? job;

  const ApplicantDetailsScreen({
    super.key,
    required this.searcher,
    this.job,
  });

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final orderUser = job != null
        ? orderProvider.orders
            .where((element) =>
                element.jobAdvertisementId == job?.id &&
                element.searcherId == searcher.id &&
                job?.companyId == companyProvider.currentCompany!.id)
            .first
        : orderProvider
            .orders
            // .where((element) =>
            //     element.searcherId == searcher.id &&
            //     job?.companyId == companyProvider.currentCompany!.id)
            .first;
    log(orderUser.id.toString(), name: 'searcherId');
    return Material(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Background(
            userImage: companyProvider.currentCompany!.img,
            userName: companyProvider.currentCompany!.nameCompany,
            isCompany: true,
            showListNotiv: true,
            title: "معلومات المتقدم",
            child: Responsive(
              mobile: ApplicantDetailsContent(
                  searcher: searcher, orderUser: orderUser),
              desktop: Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: ApplicantDetailsContent(
                        searcher: searcher, orderUser: orderUser),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.screenW! / 2.2,
            left: SizeConfig.screenW! * 0.08,
            child: Container(
              height: SizeConfig.screenW! * 0.08,
              width: SizeConfig.screenW! / 2,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon:
                          const Icon(Icons.file_download, color: Colors.white),
                      onPressed: () async {
                        await ImageUploadController().viewPDFFromUrl(
                            pdfUrl: searcher.cv.toString(),
                            fileUserName: searcher.fullName.toString(),
                            context: context);
                      },
                      tooltip: 'تحميل السيرة الذاتية',
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () async {
                        try {
                          // تحقق مما إذا كان الجهاز محمولاً أم لا
                          if (Platform.isAndroid || Platform.isIOS) {
                            // رقم الهاتف - يمكنك تغييره حسب احتياجك
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path:
                                  searcher.phone ?? '777', // ضع رقم الهاتف هنا
                            );
                            // if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                            // } else {
                            //   throw 'Could not launch phone call';
                            // }
                          } else {
                            // في حالة سطح المكتب
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('معلومات الاتصال'),
                                  content:
                                      Text('رقم الهاتف: ${searcher.phone}'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('إغلاق'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            'خطأ',
                            'لا يمكن إجراء المكالمة',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      tooltip: 'اتصال',
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      onPressed: job != null
                          ? () async {
                              if (orderUser.accept == 0) {
                                orderUser.accept = 1;
                                orderUser.statuse = 1;
                                orderUser.unAccept = 0;
                                orderUser.receptData =
                                    DateTime.now().toIso8601String();
                                await orderProvider
                                    .updateOrders(ordersModel: orderUser)
                                    .then(
                                  (value) {
                                    // إرسال إشعار القبول
                                    Get.snackbar(
                                      "تم القبول",
                                      "تم إرسال إشعار القبول بنجاح",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      icon: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.check_circle),
                                      ),
                                    );
                                  },
                                ).onError((error, stackTrace) {
                                  log(error.toString());
                                  log(stackTrace.toString());
                                  Get.snackbar(
                                    "خطأ",
                                    "حدث خطأ ما",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return null;
                                }).catchError((error, stackTrace) {
                                  log(error.toString());
                                  log(stackTrace.toString());
                                  Get.snackbar(
                                    "خطأ",
                                    "حدث خطأ ما",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return null;
                                });
                              } else {
                                Get.snackbar(
                                  "مقبول بالفعل",
                                  "لا يمكنك القبول",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          : null,
                      tooltip: 'قبول',
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.message, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              searchersModel: searcher,
                              companyModel: null,
                              chatId:
                                  '${searcher.id}_${companyProvider.currentCompany?.id}',
                            ),
                          ),
                        );
                      },
                      tooltip: 'رسالة',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.screenW! / 4,
            left: SizeConfig.screenW! / 1.6,
            // right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 116, 116, 116)
                          .withOpacity(0.1),
                      spreadRadius: 5,
                      // blurRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: searcher.img != null
                      ? NetworkImage(searcher.img!)
                      : const AssetImage('assets/images/profile.png'),
                ),
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.screenW! / 1.7,
            left: 10,
            right: 10,
            child: Center(
              child: Container(
                height: SizeConfig.screenW! * 0.1,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          'المعلومات الشخصية',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        child: Icon(Icons.info, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicantDetailsContent extends StatelessWidget {
  final OrdersModel orderUser;
  final SearchersModel searcher;

  const ApplicantDetailsContent({
    super.key,
    required this.searcher,
    required this.orderUser,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // const SizedBox(height: defaultPadding),
            const SizedBox(height: defaultPadding * 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: defaultPadding),
                _buildInfoRow(Icons.person, searcher.fullName.toString()),
                _buildInfoRow(Icons.calendar_today, "${searcher.age} سنة"),
                _buildInfoRow(
                    Icons.location_city, searcher.location.toString()),
                _buildInfoRow(Icons.work, searcher.sta.toString()),
                _buildInfoRow(Icons.date_range, searcher.bDate.toString()),
                _buildInfoRow(Icons.email, searcher.email.toString()),
                _buildInfoRow(Icons.phone, searcher.phone.toString()),
                _buildInfoRow(Icons.phone, searcher.phone.toString()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    height: SizeConfig.screenW! * 0.1,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Text(
                              'المؤهل العلمي',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Flexible(
                            flex: 8,
                            child: Icon(Icons.info, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildInfoRow(
                    Icons.account_tree_sharp, searcher.special.toString()),
                _buildInfoRow(Icons.timer, searcher.typeWorkHours.toString()),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("عودة"),
                  ),
                ),
                const SizedBox(width: defaultPadding / 4),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (orderUser.accept == 0) {
                        orderUser.accept = 1;
                        orderUser.statuse = 1;
                        orderUser.unAccept = 0;
                        orderUser.receptData = DateTime.now().toIso8601String();
                        await orderProvider
                            .updateOrders(ordersModel: orderUser)
                            .then(
                          (value) {
                            // إرسال إشعار القبول
                            Get.snackbar(
                              "تم القبول",
                              "تم إرسال إشعار القبول بنجاح",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              icon: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.check_circle),
                              ),
                            );
                          },
                        ).onError((error, stackTrace) {
                          log(error.toString());
                          log(stackTrace.toString());
                          Get.snackbar(
                            "خطأ",
                            "حدث خطأ ما",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return null;
                        }).catchError((error, stackTrace) {
                          log(error.toString());
                          log(stackTrace.toString());
                          Get.snackbar(
                            "خطأ",
                            "حدث خطأ ما",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return null;
                        });
                      } else {
                        Get.snackbar(
                          "مقبول بالفعل",
                          "لا يمكنك القبول",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text("قبول"),
                  ),
                ),
                const SizedBox(width: defaultPadding / 4),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      if (orderUser.unAccept == 0) {
                        orderUser.accept = 0;
                        orderUser.statuse = 1;
                        orderUser.unAccept = 1;
                        orderUser.presentData =
                            DateTime.now().toIso8601String();
                        await orderProvider
                            .updateOrders(ordersModel: orderUser)
                            .then(
                          (value) {
                            // إرسال إشعار الرفض
                            Get.snackbar(
                              "تم الرفض",
                              "تم إرسال إشعار الرفض بنجاح",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              icon: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.check_circle),
                              ),
                            );
                          },
                        ).onError((error, stackTrace) {
                          log(error.toString());
                          log(stackTrace.toString());
                          Get.snackbar(
                            "خطأ",
                            "حدث خطأ ما",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return null;
                        }).catchError((error, stackTrace) {
                          log(error.toString());
                          log(stackTrace.toString());
                          Get.snackbar(
                            "خطأ",
                            "حدث خطأ ما",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return null;
                        });
                      } else {
                        Get.snackbar(
                          "مرفوض بالفعل",
                          "لا يمكنك الرفض",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text("رفض"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 222, 222),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 62, 99, 154)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
