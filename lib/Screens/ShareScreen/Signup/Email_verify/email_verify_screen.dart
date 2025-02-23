import 'package:flutter/material.dart';
import 'package:jop_project/Screens/Welcome/components/welcome_image.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/Email_verify/components/otp_textfield_widget.dart';
import 'package:jop_project/responsive.dart';
import 'package:jop_project/size_config.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      title: 'التحقق من الايميل',
      child: Center(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileEmailVerifyScreen(),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: WelcomeImage(
                    imageSrc: 'assets/images/Enter-OTP-bro.png',
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 330,
                        child: OtpTextField(),
                      ),
                      // SizedBox(height: SizeConfig.screenH! / 6),
                    ],
                  ),
                )
              ],
            ),
            tablet: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: WelcomeImage(
                    imageSrc: 'assets/images/Enter-OTP-bro.png',
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SizeConfig.screenH! / 2,
                        child: const OtpTextField(),
                      ),
                      // SizedBox(height: SizeConfig.screenH! / 6),
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

class MobileEmailVerifyScreen extends StatelessWidget {
  const MobileEmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WelcomeImage(
          imageSrc: 'assets/images/Enter-OTP-bro.png',
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 14,
              child: OtpTextField(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
