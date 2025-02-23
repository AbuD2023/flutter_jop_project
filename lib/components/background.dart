import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/size_config.dart';
import 'package:jop_project/components/custom_drawer.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String title;
  final String? supTitle;
  final bool? showListNotiv;
  final bool? isCompany; // تغيير حسب نوع المستخدم الحالي
  final String? userName;
  final String? userImage;
  final int? availableJobs;

  const Background({
    super.key,
    required this.child,
    required this.title,
    this.supTitle,
    this.showListNotiv = false,
    this.isCompany,
    this.userName,
    this.userImage,
    this.availableJobs = 152,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPrimaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                width: SizeConfig.screenW,
                height: SizeConfig.screenH! / 4.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (supTitle != null)
                        Text(
                          supTitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (Navigator.canPop(context))
                Positioned(
                  top: 60,
                  child: IconButton(
                    tooltip: 'رجوع الى الخلف',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (showListNotiv!)
                Positioned(
                  top: 20,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () {
                            // عرض الـ Drawer باستخدام Overlay
                            _showDrawer(
                              context,
                              isCompany: isCompany!,
                              userName: userName!,
                              userImage: userImage!,
                              availableJobs: availableJobs!,
                            );
                          },
                          icon: const Icon(
                            Icons.list,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 252, 252, 252),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(child: child),
            ),
          ),
        ],
      ),
    );
  }

  void _showDrawer(
    BuildContext context, {
    required bool isCompany, // تغيير حسب نوع المستخدم الحالي
    required String userName,
    required String userImage,
    required int availableJobs,
  }) {
    // يجب أن تحصل على هذه المعلومات من مكان مركزي مثل Provider أو GetX

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: IntrinsicWidth(
            child: CustomDrawer(
              isCompany: isCompany,
              name: userName,
              imagePath: userImage,
              availableJobs: availableJobs,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
