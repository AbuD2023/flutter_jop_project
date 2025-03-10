import 'dart:io';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:jop_project/Screens/PDFViewer/pdf_viewer_screen.dart';

class PDFGenerator {
  static Future<void> generateProfilePDF({
    required void Function() onExportPDF,
    required String name,
    required String dateOfBirth,
    required String educationLevel,
    required String location,
    required String phone,
    required String email,
    required String specialization,
    required String gender,
    required String age,
    required List<String> skills,
    required List<String> experiences,
    required List<String> desires,
    required List<String> preferences,
    String? typeWorkHours,
    String? socialStatus,
    File? profileImage,
    required BuildContext context,
    required Function(String) onPdfGenerated,
  }) async {
    try {
      // تحميل وتضمين الخط العربي
      final arabicFont =
          await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
      final ttf = pw.Font.ttf(arabicFont);

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf,
          italic: ttf,
          boldItalic: ttf,
        ),
      );

      // تحميل صورة افتراضية إذا لم يتم توفير صورة
      final defaultImageBytes =
          await rootBundle.load('assets/images/profile.png');
      final defaultImage =
          pw.MemoryImage(defaultImageBytes.buffer.asUint8List());

      // تحويل صورة الملف إلى MemoryImage إذا كانت متوفرة
      pw.MemoryImage? profileImageData;
      if (profileImage != null) {
        final imageBytes = await profileImage.readAsBytes();
        profileImageData = pw.MemoryImage(imageBytes);
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: ttf,
            bold: ttf,
            italic: ttf,
            boldItalic: ttf,
          ),
          build: (pw.Context context) {
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // العنوان والصورة الشخصية
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'السيرة الذاتية',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            DateTime.now().toString().split(' ')[0],
                            style: const pw.TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        width: 100,
                        height: 100,
                        child: pw.ClipOval(
                          child: pw.Image(profileImageData ?? defaultImage),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // المعلومات الشخصية
                  _buildSection(
                    'المعلومات الشخصية',
                    [
                      _buildInfoRow('الاسم', name),
                      _buildInfoRow('تاريخ الميلاد', dateOfBirth),
                      _buildInfoRow('العمر', age),
                      _buildInfoRow('الجنس', gender),
                      _buildInfoRow('الحالة الاجتماعية', socialStatus ?? ''),
                      _buildInfoRow('رقم الهاتف', phone),
                      _buildInfoRow('البريد الإلكتروني', email),
                      _buildInfoRow('العنوان', location),
                      if (typeWorkHours != null)
                        _buildInfoRow('نوع العمل المفضل', typeWorkHours),
                    ],
                  ),

                  // المؤهلات العلمية
                  _buildSection(
                    'المؤهلات العلمية',
                    [
                      _buildInfoRow('المستوى التعليمي', educationLevel),
                      _buildInfoRow('التخصص', specialization),
                    ],
                  ),

                  // المهارات
                  _buildListSection('المهارات', skills),

                  // الخبرات
                  _buildListSection('الخبرات', experiences),

                  // الرغبات
                  _buildListSection('الرغبات', desires),

                  // التفضيلات
                  _buildListSection('التفضيلات', preferences),
                ],
              ),
            ];
          },
        ),
      );

      String filePath = '';

      try {
        if (Platform.isAndroid) {
          // طلب الأذونات للأندرويد
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
            if (!status.isGranted) {
              var status2 = await Permission.manageExternalStorage.status;
              if (!status2.isGranted) {
                status2 = await Permission.manageExternalStorage.request();
                if (!status2.isGranted) {
                  throw Exception(
                      'تم رفض إذن الوصول إلى التخزين manageExternalStorage');
                }
              }
            }
          }

          // استخدام المسار العام للتنزيلات في الأندرويد
          final downloadsDir = Directory('/storage/emulated/0/Download');
          if (!await downloadsDir.exists()) {
            throw Exception('مجلد التنزيلات غير موجود');
          }

          final cvJobDir = Directory('${downloadsDir.path}/CV Job');
          if (!await cvJobDir.exists()) {
            await cvJobDir.create(recursive: true);
          }

          final fileName =
              'CV_${name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
          final file = File('${cvJobDir.path}/$fileName');

          // حفظ الملف
          await file.writeAsBytes(await pdf.save());

          filePath = file.path; // تخزين مسار الملف
          onPdfGenerated(filePath); // استدعاء callback مع مسار الملف

          // عرض رسالة نجاح
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم حفظ الملف في ${file.path}'),
              duration: const Duration(seconds: 3),
            ),
          );

          // فتح الملف في التطبيق
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                onSave: onExportPDF,
                filePath: file.path,
                fileName: fileName,
              ),
            ),
          );
        } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // لأنظمة سطح المكتب
          final homeDir = Platform.environment['HOME'] ??
              Platform.environment['USERPROFILE'];
          if (homeDir != null) {
            final documentsDir = Directory(path.join(homeDir, 'Documents'));
            final cvJobDir = Directory(path.join(documentsDir.path, 'CV Job'));
            if (!await cvJobDir.exists()) {
              await cvJobDir.create(recursive: true);
            }
            final fileName =
                'CV_${name}_${DateTime.now().toString().replaceAll(RegExp(r'[^\w]'), '_')}.pdf';
            final file = File(path.join(cvJobDir.path, fileName));

            // حفظ الملف
            await file.writeAsBytes(await pdf.save());

            filePath = file.path; // تخزين مسار الملف
            onPdfGenerated(filePath); // استدعاء callback مع مسار الملف

            // فتح الملف بالتطبيق الافتراضي لسطح المكتب
            await OpenFile.open(file.path);

            // عرض رسالة نجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم حفظ الملف في ${file.path}'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('Error saving PDF: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }

  // دالة مساعدة لإنشاء صف معلومات
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء قسم
  static pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(),
        ...children,
        pw.SizedBox(height: 20),
      ],
    );
  }

  // دالة مساعدة لإنشاء قسم القوائم
  static pw.Widget _buildListSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(),
        pw.Wrap(
          spacing: 5,
          runSpacing: 5,
          children: items
              .map((item) => pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(5)),
                    ),
                    child: pw.Text(item),
                  ))
              .toList(),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }
}
