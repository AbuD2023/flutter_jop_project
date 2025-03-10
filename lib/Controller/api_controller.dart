import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class ApiController {
  // static const String _baseUrl = 'https://bar.somee.com/api/';
  static const String _baseUrl = 'https://alumniclubsoft.somee.com/api/';
  final Dio _dio;

  ApiController() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 5);
    _dio.options.receiveTimeout = const Duration(minutes: 5);

    // إضافة Interceptors للتعامل مع الطلبات والاستجابات
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // إضافة الهيدرز الافتراضية
        options.headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'accept': 'text/plain',
          // يمكنك إضافة توكن المصادقة هنا
          // 'Authorization': 'Bearer $token',
        });
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // معالجة الاستجابة إذا لزم الأمر
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // معالجة الأخطاء
        log('خطأ في الطلب: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<T> get<T>({
    required String endpoint,
    required T Function(dynamic json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      log(response.statusCode.toString(), name: 'status code');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل في جلب البيانات: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('خطأ في جلب البيانات: $e');
      rethrow;
    }
  }

  // دالة POST
  Future<T> post<T>({
    required String endpoint,
    required dynamic data,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      final response = await _dio
          .post(
        endpoint,
        data: data,
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(['خطاء، Time Out is { 15s }']);
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل في إرسال البيانات: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('خطأ في إرسال البيانات: $e');
      rethrow;
    }
  }

  // دالة PUT
  Future<T> put<T>({
    required String endpoint,
    required dynamic data,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      // إضافة logging للبيانات المرسلة
      log('PUT Request to: $endpoint');
      log('Request Data: ${json.encode(data)}');

      final response = await _dio.put(
        endpoint,
        data: data,
      );

      // إضافة logging لاستجابة السيرفر
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // التحقق من نوع البيانات المستلمة
        if (response.data == null) {
          // إذا كانت البيانات فارغة، نرجع البيانات الأصلية المرسلة
          return fromJson(data as Map<String, dynamic>);
        } else if (response.data is String) {
          // إذا كانت الاستجابة نصية، نحاول تحويلها إلى JSON
          try {
            final Map<String, dynamic> jsonData = json.decode(response.data);
            return fromJson(jsonData);
          } catch (e) {
            // إذا فشل التحويل، نرجع البيانات الأصلية
            return fromJson(data as Map<String, dynamic>);
          }
        } else if (response.data is Map<String, dynamic>) {
          // إذا كانت البيانات بالتنسيق المتوقع
          return fromJson(response.data as Map<String, dynamic>);
        }
        // إذا لم نتمكن من معالجة البيانات، نرجع البيانات الأصلية
        return fromJson(data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'فشل في تحديث البيانات: ${response.statusCode}\nResponse: ${response.data}',
        );
      }
    } on DioException catch (e) {
      log('خطأ Dio في تحديث البيانات: ${e.message}');
      if (e.response != null) {
        log('بيانات الخطأ: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('خطأ غير متوقع في تحديث البيانات: $e');
      rethrow;
    }
  }

  // دالة DELETE
  Future<void> delete({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      final response = await _dio.delete(endpoint);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'فشل في حذف البيانات: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('خطأ في حذف البيانات: $e');
      rethrow;
    }
  }
}
  // // مثال على الاستخدام:
  // Future<List<ApplicantModel>> getApplicants() async {
  //   return get<ApplicantModel>(
  //     endpoint: 'applicants',
  //     fromJson: (json) => ApplicantModel.fromJson(json),
  //     queryParameters: {
  //       'page': '1',
  //       'limit': '10',
  //     },
  //   );
  // }

  // // مثال آخر للشركات:
  // Future<List<CompanyModel>> getCompanies() async {
  //   return get<CompanyModel>(
  //     endpoint: 'companies',
  //     fromJson: (json) => CompanyModel.fromJson(json),
  //     headers: {
  //       'X-Custom-Header': 'value',
  //     },
  //   );
  // }

// مثال على استخدام الدالة:
/*
final apiController = ApiController();

try {
  final applicants = await apiController.getApplicants();
  // استخدام البيانات...
} catch (e) {
  print('Error: $e');
}
*/
