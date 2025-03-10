import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/company_dashboard_screen.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../ForgotPassword/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final companyProvider =
        Provider.of<CompanySigninLoginProvider>(context, listen: false);

    final searcherProvider =
        Provider.of<SearcherSigninLoginProvider>(context, listen: false);

    try {
      final loginResponse = await companyProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final loginResponseSearcher = await searcherProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (loginResponse.userType == "Admin") {
        if (companyProvider.currentCompany != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyDashboardScreen(
                company: companyProvider.currentCompany!,
              ),
            ),
            (route) => false,
          );
        }
      }
      if (loginResponseSearcher.userType == "Searchers") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      log(e.toString(), name: '_login');
      if (e.toString().contains('[خطاء، Time Out is {')) {
        Get.snackbar('خطاء', 'تاكد من اتصال بالانترنت',
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() {
          _error = 'فشل تسجيل الدخول: تاكد من إتصالك بالانترنت';
        });
      } else if (e.toString().contains(
          'The status code of 401 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"')) {
        Get.snackbar('خطاء', 'خطأ في كلمة المرور او البريد الالكتروني',
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() {
          _error = 'فشل تسجيل الدخول: تاكد من البريد الالكتروني او كلمة المرور';
        });
      } else {
        Get.snackbar('خطاء', 'خطأ غير متوقع في السيرفر',
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() {
          _error =
              'فشل تسجيل الدخول: خطأ غير متوقع في السيرفر، حاول مجداً بعد 5 دقائق';
        });
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(_error ?? 'حدث خطأ غير متوقع')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال البريد الإلكتروني';
              }
              return null;
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusColor: kBorderColor,
              hintText: "البريد الالكتروني",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(
                  Icons.person,
                  color: kBorderColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
              obscureText: obscureText,
              cursorColor: kPrimaryColor,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور';
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: kBorderColor, width: 2),
                ),
                hintText: "كلمة المرور",
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(
                    Icons.lock,
                    color: kBorderColor,
                  ),
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(Icons.visibility),
                ),
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _error!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Text(
                "نسيت كلمة المرور؟",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: companyProvider.isLoading ? null : _login,
            child: companyProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("تسجيل الدخول".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
