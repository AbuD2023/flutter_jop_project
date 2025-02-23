import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/Screens/JopScreen/ChatScreen/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class HomeListTileWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String phone;
  final void Function()? onTap;
  const HomeListTileWidget({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.phone,
  });

  @override
  State<HomeListTileWidget> createState() => _HomeListTileWidgetState();
}

class _HomeListTileWidgetState extends State<HomeListTileWidget> {
  @override
  Widget build(BuildContext context) {
    const double size = 15;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        onTap: widget.onTap,
        leading: Icon(
          widget.icon,
          size: 50,
        ),
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.integration_instructions_outlined,
              color: Colors.red,
              size: size,
            ),
            Container(
              margin: EdgeInsets.all(2),
              width: 1,
              height: defaultPadding * 0.8,
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userName: widget.title,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_rounded,
                color: kPrimaryLightColor,
                size: size,
              ),
            ),
            InkWell(
              onTap: () async {
                try {
                  // تحقق مما إذا كان الجهاز محمولاً أم لا
                  if (Platform.isAndroid || Platform.isIOS) {
                    // رقم الهاتف - يمكنك تغييره حسب احتياجك
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: widget.phone, // ضع رقم الهاتف هنا
                    );
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      throw 'Could not launch phone call';
                    }
                  } else {
                    // في حالة سطح المكتب
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('معلومات الاتصال'),
                          content: Text('رقم الهاتف: ${widget.phone}'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('إغلاق'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لا يمكن إجراء المكالمة'),
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.phone,
                color: kPrimaryLightColor,
                size: size,
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.report,
                  color: kPrimaryLightColor,
                  size: size,
                ),
                Text(
                  '3s ago',
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
