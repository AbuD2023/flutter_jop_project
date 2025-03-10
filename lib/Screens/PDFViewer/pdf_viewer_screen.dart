import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Profile/components/background_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:provider/provider.dart';

class PDFViewerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;
  final void Function() onSave;

  const PDFViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundProfile(
      // imageSrc:
      //     context.read<SearcherSigninLoginProvider>().currentSearcher!.img,
      isButtom: true,
      onSave: onSave,
      isProfileImage: false,
      title: fileName,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            Share.shareXFiles([XFile(filePath)], text: 'السيرة الذاتية');
          },
        ),
      ],
      child: SfPdfViewer.file(
        File(filePath),
        canShowScrollHead: false,
        pageSpacing: 8,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
