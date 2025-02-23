import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              login ? "لا امتلك حساب ؟ " : "لدي حساب بالفعل ؟ ",
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: kPrimaryColor),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: press as void Function()?,
              child: Text(
                login ? "إنشاء حساب" : "تسجيل دخول",
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
