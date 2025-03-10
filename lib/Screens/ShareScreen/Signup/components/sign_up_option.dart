import 'package:flutter/material.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/Company_Signup/sign_up_company_screen.dart';
import 'package:jop_project/Screens/Welcome/components/cart_sign_up_option_btn.dart';
import 'package:jop_project/Screens/ShareScreen/Signup/components/Jop_signup/sign_up_job_screen.dart';
import 'package:jop_project/size_config.dart';

class SignUpOption extends StatelessWidget {
  const SignUpOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CartSignUpOptionBtn(
          icon: Icons.person_add_alt_1_rounded,
          // titleIcon: 'موظف',
          text: 'باحث عن وظيفة شاغرة  ',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpJobScreen(),
                ));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CartSignUpOptionBtn(
            icon: Icons.apartment_outlined,
            // titleIcon: 'شركــة',
            text: 'باحث عن موظفين  ',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpCompanyScreen(),
                  ));
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: SizeConfig.screenW! / 4,
            child: ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'العودة',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
