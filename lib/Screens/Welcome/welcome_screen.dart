import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';

import '../../components/background.dart';
import '../../responsive.dart';
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      title: 'مرحباً بك',
      child: SafeArea(
        top: false,
        bottom: false,
        child: Responsive(
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: WelcomeImage(imageSrc: 'assets/images/GroupLogo.png'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginAndSignupBtn(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          mobile: MobileWelcomeScreen(),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(imageSrc: 'assets/images/GroupLogo.png'),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: LoginAndSignupBtn(),
        ),
      ],
    );
  }
}
