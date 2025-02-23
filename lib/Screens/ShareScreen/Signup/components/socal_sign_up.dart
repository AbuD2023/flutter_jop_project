import 'package:flutter/material.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/or_divider.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/social_icon.dart';



class SocalSignUp extends StatelessWidget {
  const SocalSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OrDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocalIcon(
              iconSrc: "assets/icons/facebook.svg",
              press: () {},
            ),
            SocalIcon(
              iconSrc: "assets/icons/twitter.svg",
              press: () {},
            ),
            SocalIcon(
              iconSrc: "assets/icons/google-plus.svg",
              press: () {},
            ),
          ],
        ),
      ],
    );
  }
}