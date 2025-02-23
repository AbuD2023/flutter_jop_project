import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/size_config.dart';

import '../../ShareScreen/Login/login_screen.dart';
import '../../ShareScreen/Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: SizeConfig.screenW! - 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            child: Text(
              "تسجيل الدخول".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding / 4),
        SizedBox(
          width: SizeConfig.screenW! - 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
            child: Text(
              "إنشاء حساب".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ar '),
              Container(
                width: 1,
                height: SizeConfig.screenW! * 0.1,
                color: Colors.white,
              ),
              Text(
                "  اللغة".toUpperCase(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
