import 'package:flutter/material.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/Jop_signup/components/sign_up_job_form.dart';
import 'package:jop_project/Screens/Welcome/components/welcome_image.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';

class SignUpJobScreen extends StatefulWidget {
  const SignUpJobScreen({super.key});

  @override
  State<SignUpJobScreen> createState() => _SignUpJobScreenState();
}

class _SignUpJobScreenState extends State<SignUpJobScreen> {
  @override
  Widget build(BuildContext context) {
    return const Background(
      title: 'إنشاء حساب',
      supTitle: 'موظف',
      child: Center(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: MobileSignupScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: WelcomeImage(
                    imageSrc: 'assets/images/Login-rafiki.png',
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: SignUpJobForm(),
                      ),
                      SizedBox(height: defaultPadding / 2),
                    ],
                  ),
                )
              ],
            ),
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
          imageHeight: 150,
          imageSrc: 'assets/images/Login-rafiki.png',
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 14,
              child: SignUpJobForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
