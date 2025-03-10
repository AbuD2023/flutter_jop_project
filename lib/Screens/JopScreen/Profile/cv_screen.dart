import 'package:flutter/material.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Profile/components/background_profile.dart';
import 'package:jop_project/Screens/JopScreen/Profile/cv_settings_screen.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';

class CVScreen extends StatelessWidget {
  const CVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundProfile(
      imageSrc:
          context.read<SearcherSigninLoginProvider>().currentSearcher?.img,
      isButtom: false,
      title: 'البيانات الشخصية',
      child: Responsive(
        mobile: body(context),
        desktop: body(context),
      ),
    );
  }

  SizedBox body(BuildContext context) {
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    return SizedBox(
      width: SizeConfig.screenW! - 20,
      // height: SizeConfig.screenH! / 1.8,
      child: Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.screenH! / 10, bottom: SizeConfig.screenH! / 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${searcherProvider.currentSearcher?.fullName}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${searcherProvider.currentSearcher?.bDate}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
            Form(
                child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  customTextFild(
                    hintText: "إدخال السيرة الذاتية يدوياً",
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CVSettingsScreen(),
                          ));
                    },
                  ),
                  customTextFild(
                    hintText: "رفع ملف السيرة الذاتية",
                    readOnly: true,
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Padding customTextFild({
    required String hintText,
    void Function()? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        readOnly: readOnly,
        // maxLines: 4,
        // minLines: 2,
        onTap: onTap,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.newline,
        cursorColor: kPrimaryColor,
        onSaved: (email) {},
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: kBorderColor, width: 2.0),
          ),
          hintText: hintText,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Icon(Icons.arrow_back_rounded),
          ),
        ),
      ),
    );
  }
}
