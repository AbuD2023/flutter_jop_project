import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../components/already_have_an_account_acheck.dart';
import '../../../../../../constants.dart';
import '../../../../Login/login_screen.dart';

class SignUpJobForm extends StatefulWidget {
  const SignUpJobForm({
    super.key,
  });

  @override
  State<SignUpJobForm> createState() => _SignUpJobFormState();
}

class _SignUpJobFormState extends State<SignUpJobForm> {
  final formKey = GlobalKey<FormState>();
  final nameCompanyController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  final specialController = TextEditingController();
  final educationLevelController = TextEditingController();
  final phoneController = TextEditingController();
  final bDateController = TextEditingController();
  String gendr = '';
  @override
  Widget build(BuildContext context) {
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCompanyController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "الأسم الرباعي",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: locationController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2.0),
                ),
                hintText: "مكان السكن حالياً",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_on_outlined, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: ageController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              hintText: "العمر",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.numbers, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: specialController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2.0),
                ),
                hintText: "التخصص",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.school_outlined, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: educationLevelController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.done,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2),
              ),
              hintText: "المستوى التعليمي",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.leaderboard_outlined, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: phoneController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2.0),
                ),
                hintText: "رقم الهاتف",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.school_outlined, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: bDateController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.done,
            cursorColor: kPrimaryColor,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: kPrimaryColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                setState(() {
                  bDateController.text = formattedDate;
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2),
              ),
              hintText: "تاريخ الميلاد",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.calendar_today, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: emailController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2.0),
                ),
                hintText: "البريد الالكتروني",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.attach_email_outlined, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: passwordController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2),
              ),
              hintText: "كلمة المرور",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding * 2),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الجنس:',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RadioListTile(
                        title: const Text('ذكر'),
                        value: 'ذكر',
                        groupValue: gendr,
                        onChanged: (value) {
                          setState(() {
                            gendr = value!;
                          });
                          log(value.toString());
                        },
                      ),
                      RadioListTile(
                        title: const Text('انثى'),
                        value: 'انثى',
                        groupValue: gendr,
                        onChanged: (value) {
                          setState(() {
                            gendr = value!;
                          });
                          log(value.toString());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  (gendr.isNotEmpty || gendr != '')) {
                if (!searcherProvider.isLoading) {
                  await showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ).timeout(
                    const Duration(seconds: 3),
                    onTimeout: () async {
                      final searcher = SearchersModel(
                        id: 0,
                        fullName: nameCompanyController.text,
                        email: emailController.text,
                        pass: passwordController.text,
                        gendr: gendr,
                        age: ageController.text,
                        bDate: bDateController.text,
                        location: locationController.text,
                        phone: phoneController.text,
                        special: specialController.text,
                        educationLevel: educationLevelController.text,
                        cv: null,
                        img: null,
                        sta: null,
                        typeWorkHours: null,
                        userId: null,
                      );
                      await searcherProvider.registerSearcher(
                          searchersModel: searcher);
                      if (!searcherProvider.isLoading) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                      if (searcherProvider.error == null) {
                        Get.snackbar('تم التسجيل بنجاح', '',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                            icon: const Icon(Icons.check_circle),
                            margin: const EdgeInsets.all(10),
                            snackPosition: SnackPosition.BOTTOM);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  );
                }
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const EmailVerifyScreen(),
                //     ));
              }
            },
            child: searcherProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text("تسجيل".toUpperCase()),
          ),
          if (searcherProvider.error != null)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'خطاء في الإميل او كلمة المرور',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding * 2),
        ],
      ),
    );
  }
}
