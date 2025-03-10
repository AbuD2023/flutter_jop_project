import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/Models/job_advertisement_model.dart';
import 'package:jop_project/Models/orders_model.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Profile/cv_screen.dart';
import 'package:jop_project/Screens/ShareScreen/Login/login_screen.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class JopInfoScreen extends StatelessWidget {
  final JobAdvertisementModel jobData;
  final CompanyModel companyData;
  final OrdersModel? orderData;

  const JopInfoScreen({
    super.key,
    required this.jobData,
    required this.companyData,
    this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      isCompany: false,
      showListNotiv: true,
      title: 'عن الوظيفة',
      child: Center(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: MobileHomeJopInfoScreen(
                jobData: jobData,
                companyData: companyData,
                orderData: orderData),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: companyData.img != null
                            ? Image.network(
                                companyData.img!,
                                fit: BoxFit.fill,
                              )
                            : const Icon(Icons.image_not_supported_outlined),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        color: const Color(0xFF6B8CC7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyData.nameCompany.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              jobData.location.toString(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 90, 90, 90),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InfoBodyWidget(
                      jobData: jobData,
                      orderData: orderData,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileHomeJopInfoScreen extends StatelessWidget {
  final JobAdvertisementModel jobData;
  final CompanyModel companyData;
  final OrdersModel? orderData;

  const MobileHomeJopInfoScreen({
    super.key,
    required this.jobData,
    required this.companyData,
    this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: SizeConfig.screenW! / 1.2,
              child: CardMainInfoWidget(
                  jobData: jobData, companyData: companyData),
            ),
          ),
          const SizedBox(height: 16),
          InfoBodyWidget(jobData: jobData, orderData: orderData),
        ],
      ),
    );
  }
}

class InfoBodyWidget extends StatelessWidget {
  final JobAdvertisementModel jobData;
  final OrdersModel? orderData;

  const InfoBodyWidget({
    super.key,
    required this.jobData,
    this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final isBooking = orderProvider.orders
        .where(
          (element) =>
              element.jobAdvertisementId == jobData.id &&
              element.searcherId == searcherProvider.currentSearcher!.id,
        )
        .isNotEmpty;
    final accept = orderProvider.orders
        .where(
          (element) =>
              element.jobAdvertisementId == jobData.id &&
              element.searcherId == searcherProvider.currentSearcher!.id &&
              element.accept == 1,
        )
        .isNotEmpty;
    final unAccept = orderProvider.orders
        .where(
          (element) =>
              element.jobAdvertisementId == jobData.id &&
              element.searcherId == searcherProvider.currentSearcher!.id &&
              element.unAccept == 1,
        )
        .isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'معلومات الوظيفة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B8CC7),
          ),
        ),
        const Divider(
          color: Color(0xFF6B8CC7),
        ),
        RectanglText(description: jobData.descrip.toString()),
        const SizedBox(height: 16),
        _buildInfoItem(Icons.work, 'أسم الوظيفة', jobData.nameJob.toString()),
        _buildInfoItem(Icons.work, 'عنوان', jobData.location.toString()),
        _buildInfoItem(
            Icons.school, 'المؤهلات المطلوبة', jobData.special.toString()),
        _buildInfoItem(
            Icons.school, 'مدة الخبرة', jobData.periodExper.toString()),
        _buildInfoItem(
            Icons.access_time, 'نوع الدوام', jobData.permanenceType.toString()),
        _buildInfoItem(
            Icons.location_on, 'المنطقة', jobData.typeOfPlace.toString()),
        _buildInfoItem(
            Icons.calendar_today, 'مدة التقديم', jobData.timeWork.toString()),
        _buildInfoItem(Icons.attach_money, 'الراتب', jobData.salry.toString()),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: orderData == null
              ? !isBooking
                  ? ElevatedButton(
                      onPressed: () async {
                        if (searcherProvider.currentSearcher!.id == null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        } else if (searcherProvider.currentSearcher!.cv !=
                            null) {
                          await orderProvider.addOrders(
                            ordersModel: OrdersModel(
                              id: 0,
                              numberPresent: 0,
                              jobAdvertisementId: jobData.id,
                              searcherId: searcherProvider.currentSearcher!.id,
                              presentData: intl.DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              receptData: intl.DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              statuse: 1,
                              accept: 0,
                              unAccept: 0,
                              time: intl.DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                            ),
                          );
                          if (orderProvider.error == null) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                        } else if (searcherProvider.currentSearcher!.cv ==
                            null) {
                          Get.showOverlay(
                            asyncFunction: () async {
                              await Future.delayed(const Duration(seconds: 2));
                              // Get.back();
                            },
                            loadingWidget: Center(
                              child: Material(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'يجب عليك اما إرفاق او إنشاء السيرة الذاتية أولا'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('الغاء')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CVScreen(),
                                                  ));
                                            },
                                            child: Text('إنشاء')),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3B77),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: orderProvider.isLoading
                          ? const CircularProgressIndicator()
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.language, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'تقديم على الوظيفة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    )
                  : InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (contextShowDialog) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  backgroundColor: Colors.grey,
                                  title: const Text(
                                    'حالة التقديم',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.white),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          accept
                                              ? 'تم قبولك في الوظيفة'
                                              : unAccept
                                                  ? 'لم يتم قبولك في الوضيفة'
                                                  : 'في حالة الإنتضار',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: accept
                                                  ? Color.fromARGB(
                                                      255, 1, 149, 68)
                                                  : unAccept
                                                      ? Colors.red
                                                      : const Color.fromARGB(
                                                          255, 250, 189, 8)),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(contextShowDialog);
                                          },
                                          child: const Text('رجوع'))
                                    ],
                                  ),
                                )));
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          color: Color.fromARGB(255, 1, 149, 68),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'تم التقديم',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
              : const SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    color: Color.fromARGB(255, 1, 149, 68),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'تم التقديم',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF6B8CC7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                border: Border.all(color: kBorderColor)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: kBorderColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B8CC7),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class RectanglText extends StatelessWidget {
  final String description;

  const RectanglText({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8CC7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'الوصف',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardMainInfoWidget extends StatelessWidget {
  final JobAdvertisementModel jobData;
  final CompanyModel companyData;

  const CardMainInfoWidget({
    super.key,
    required this.jobData,
    required this.companyData,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Flexible(
                child: CircleAvatar(
                  backgroundImage: companyData.img == null
                      ? const AssetImage('assets/images/profile.png')
                      : NetworkImage(companyData.img.toString()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyData.nameCompany.toString(),
                      style: const TextStyle(
                        color: kBorderColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      jobData.location.toString(),
                      style: const TextStyle(
                        color: kBorderColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
