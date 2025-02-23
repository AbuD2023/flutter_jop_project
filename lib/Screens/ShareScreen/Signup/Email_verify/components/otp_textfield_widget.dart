import 'package:flutter/material.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import 'package:jop_project/size_config.dart';
import 'package:pinput/pinput.dart';

class OtpTextField extends StatefulWidget {
  const OtpTextField({super.key});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  final focusedBorderColor = Colors.black;
  final fillColor = const Color.fromRGBO(243, 246, 249, 0);
  final borderColor = Colors.grey[800]!;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Directionality(
              // Specify direction if desired
              textDirection: TextDirection.ltr,
              child: Pinput(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يجب ملى الحقول';
                  }
                  return null;
                },
                length: 5,
                controller: pinController,
                defaultPinTheme: defaultPinTheme,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 24,
                      height: 2,
                      color: Colors.black,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenW! / 6),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: const Text('تحقق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onPressed() async {
    if (pinController.text.length < 4) {
      pinController.clear();
    }
    if (formKey.currentState!.validate()) {
      await showDialog(
          context: context,
          builder: (context) => Container(
                color: const Color.fromARGB(83, 255, 255, 255),
                width: SizeConfig.screenW,
                height: SizeConfig.screenH,
                child: Center(child: CircularProgressIndicator()),
              )).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
      await showDialog(
          context: context,
          builder: (context) => Container(
                color: const Color.fromARGB(83, 255, 255, 255),
                width: SizeConfig.screenW,
                height: SizeConfig.screenH,
                child: Center(
                    child: Image.asset(
                  'assets/images/verift-sucssing.png',
                  width: 250,
                  height: 250,
                )),
              )).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const HomeScreen()),
            ModalRoute.withName(''),
          );
        },
      );
    } else {}
  }
}
