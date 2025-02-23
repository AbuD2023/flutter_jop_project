import 'package:flutter/material.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  final String? title;
  final String imageSrc;
  final double imageHeight;
  const WelcomeImage({
    super.key,
    this.title,
    required this.imageSrc,
    this.imageHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title != null)
          const Text(
            "title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        if (title != null) const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
                flex: 0,
                child: Image.asset(
                  imageSrc,
                  // height: imageHeight,
                )),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
