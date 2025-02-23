import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:jop_project/Screens/PDFViewer/pdf_viewer_screen.dart';

class ImageUploadController {
  static const String _baseUrl = 'https://bar.somee.com/api/';
  final Dio _dio;

  ImageUploadController() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 5);
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      // إنشاء FormData
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // إرسال الطلب
      final response = await _dio.post(
        'ImageUpload/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // التحقق من الاستجابة
      if (response.statusCode == 200) {
        // إرجاع رابط الصورة
        log('تم رفع الصورة بنجاح: ${response.data}');
        return response.data['imageUrl'] as String;
      } else {
        log('فشل في رفع ملف الصورة: ${response.statusCode}');
        log('فشل في رفع الصورة: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('خطأ في رفع الصورة: $e');
      return null;
    }
  }

  // دالة رفع ملف PDF
  Future<String?> uploadPDF(File pdfFile) async {
    try {
      String fileName = pdfFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          pdfFile.path,
          filename: fileName,
          // contentType: MediaType, // تحديد نوع المحتوى كـ PDF
        ),
      });

      final response = await _dio.post(
        'ImageUpload/uploadPdf',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        log('تم رفع الملف بنجاح: ${response.data}');
        return response.data['pdfUrl'] as String;
      } else {
        log('فشل في رفع ملف PDF: ${response.statusCode}');
        log('رسالة الخطأ: ${response.data}');
        return null;
      }
    } catch (e) {
      log('خطأ في رفع ملف PDF: $e');
      return null;
    }
  }

  Future<void> downloadPDF({
    required String pdfUrl,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      // التحقق من الأذونات على نظام Android
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            status = await Permission.manageExternalStorage.request();
            if (!status.isGranted) {
              throw Exception('تم رفض إذن الوصول إلى التخزين');
            }
          }
        }
      }

      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final response = await _dio.get(
        pdfUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // تحديد مسار حفظ الملف
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download/CV Job')
          : await getApplicationDocumentsDirectory();

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.data);

      // إغلاق مؤشر التحميل
      Navigator.pop(context);

      // عرض رسالة نجاح
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('تم تحميل الملف في ${file.path}'),
      //     duration: const Duration(seconds: 3),
      //   ),
      // );
      getx.Get.snackbar(
        'تم تحميل الملف',
        'تم تحميل الملف في ${file.path}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle),
        margin: const EdgeInsets.all(10),
      );

      // فتح الملف في عارض PDF
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            filePath: file.path,
            fileName: fileName,
            onSave: () {
              // إضافة الكود لحفظ الملف هنا
            },
          ),
        ),
      );
    } catch (e) {
      // إغلاق مؤشر التحميل إذا كان مفتوحاً
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      log('خطأ في تحميل الملف: $e');
      getx.Get.snackbar(
        'فشل في تحميل الملف',
        'فشل في تحميل الملف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error),
        margin: const EdgeInsets.all(10),
      );
    }
  }

  // دالة لتنزيل وعرض ملف PDF من API
  Future<void> viewPDFFromUrl({
    required String pdfUrl,
    required BuildContext context,
    required String fileUserName,
  }) async {
    try {
      // إظهار مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // تنزيل الملف من API
      final response = await _dio.get(
        pdfUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      // تحديد مسار مؤقت لحفظ الملف
      final tempDir = await getTemporaryDirectory();
      final fileName = '$fileUserName.pdf';
      final file = File('${tempDir.path}/$fileName');

      // حفظ الملف مؤقتاً
      await file.writeAsBytes(response.data);

      // إغلاق مؤشر التحميل
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // عرض الملف في عارض PDF
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            filePath: file.path,
            fileName: fileName,
            onSave: () async {
              // حفظ الملف في مجلد التنزيلات
              if (Platform.isAndroid) {
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  status = await Permission.storage.request();
                  if (!status.isGranted) {
                    throw Exception('تم رفض إذن الوصول إلى التخزين');
                  }
                }

                final downloadsDir =
                    Directory('/storage/emulated/0/Download/CV Job');
                if (!await downloadsDir.exists()) {
                  await downloadsDir.create(recursive: true);
                }

                final savedFile = File('${downloadsDir.path}/$fileName');
                await file.copy(savedFile.path);

                getx.Get.snackbar(
                  'تم حفظ الملف',
                  'تم حفظ الملف في ${savedFile.path}',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 5),
                  icon: const Icon(Icons.check_circle),
                  margin: const EdgeInsets.all(10),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    } catch (e) {
      // إغلاق مؤشر التحميل إذا كان مفتوحاً
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      log('خطأ في تحميل الملف: $e');
      getx.Get.snackbar(
        'فشل في تحميل الملف',
        'فشل في تحميل الملف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error),
        margin: const EdgeInsets.all(10),
      );
    }
  }
}
