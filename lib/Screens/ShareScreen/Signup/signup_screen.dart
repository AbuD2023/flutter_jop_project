import 'package:flutter/material.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/sign_up_option.dart';
import 'package:jop_project/Screens/Welcome/components/welcome_image.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';
import '../../../components/background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      title: 'إنشاء حساب',
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: WelcomeImage(
                  imageSrc: 'assets/images/login.png',
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpOption(),
                    ),
                    SizedBox(height: defaultPadding / 2),
                    // SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(
          imageSrc: 'assets/images/login.png',
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 14,
              child: SignUpOption(),
              // child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
