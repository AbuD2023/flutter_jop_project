// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:url_launcher/url_launcher.dart';

// class PDFViewerScreen extends StatelessWidget {
//   final File file;
//   final String title;

//   const PDFViewerScreen({
//     super.key,
//     required this.file,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               Share.shareXFiles([XFile(file.path)]);
//             },
//           ),
//           // إضافة زر فتح في المتصفح للديسكتوب
//           if (!kIsWeb &&
//               (Platform.isWindows || Platform.isMacOS || Platform.isLinux))
//             IconButton(
//               icon: const Icon(Icons.open_in_browser),
//               onPressed: () async {
//                 final url = Uri.file(file.path);
//                 if (await canLaunchUrl(url)) {
//                   await launchUrl(url);
//                 }
//               },
//             ),
//         ],
//       ),
//       body: Platform.isAndroid || Platform.isIOS
//           ? PDFView(
//               filePath: file.path,
//               enableSwipe: true,
//               swipeHorizontal: false,
//               autoSpacing: false,
//               pageFling: false,
//               pageSnap: false,
//               defaultPage: 0,
//               fitPolicy: FitPolicy.BOTH,
//               preventLinkNavigation: false,
//             )
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('تم حفظ الملف بنجاح'),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       final url = Uri.file(file.path);
//                       if (await canLaunchUrl(url)) {
//                         await launchUrl(url);
//                       }
//                     },
//                     icon: const Icon(Icons.open_in_browser),
//                     label: const Text('فتح الملف'),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
