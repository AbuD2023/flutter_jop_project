import 'package:flutter/material.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/size_config.dart';

class CartSignUpOptionBtn extends StatelessWidget {
  const CartSignUpOptionBtn({
    super.key,
    required this.text,
    // required this.titleIcon,
    required this.icon,
    this.onTap,
  });

  final String text;
  // final String titleIcon;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenW! * 0.15,
        // padding: EdgeInsets.all(8),
        // width: SizeConfig.screenW!,
        // height: SizeConfig.screenW! / 6.5,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(2505),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  text,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              SizedBox(
                width: SizeConfig.screenW! * 0.01,
              ),
              Container(
                width: 1,
                height: SizeConfig.screenW! * 0.1,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.screenW! * 0.01),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   titleIcon,
                    //   style: Theme.of(context).textTheme.labelMedium,
                    //   overflow: TextOverflow.clip,
                    // ),
                    // const SizedBox(
                    //   width: defaultPadding / 4,
                    // ),
                    Icon(
                      icon,
                      color: Colors.white,
                      // size: SizeConfig.screenW! * 0.1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
