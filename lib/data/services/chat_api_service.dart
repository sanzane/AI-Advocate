import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/app_exception.dart';
import '../models/chat_models.dart';

/// The only place the Dio client is configured (single base URL).
Dio createApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: AppConfig.requestTimeout,
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ),
  );
}

/// Talks to POST /api/chat on our FastAPI backend.
class ChatApiService {
  ChatApiService(this._dio);

  final Dio _dio;

  Future<ChatResponse> sendMessage(ChatRequest request) async {
    if (request.message.trim().isEmpty) {
      throw const AppException('Please type a question first.',
          retryable: false);
    }
    try {
      final res = await _dio.post<Map<String, dynamic>>('/api/chat',
          data: request.toJson());
      final data = res.data;
      if (data == null) {
        throw const AppException('The server returned an empty response.');
      }
      return ChatResponse.fromJson(data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw _mapError(e);
    } catch (_) {
      throw const AppException(
          'The server sent a response the app could not read.');
    }
  }

  AppException _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return const AppException(
          "Can't reach the AI Advocate server. Check that the backend is running and the app's API address is correct.",
        );
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppException(
            'The server took too long to respond. Please try again.');
      default:
        break;
    }
    final status = e.response?.statusCode;
    final detail = _detailMessage(e.response?.data);
    if (status == 422) {
      return const AppException(
          'That question could not be processed. Please rephrase it and try again.');
    }
    if (detail != null) {
      return AppException(detail, retryable: status != null && status >= 500);
    }
    return AppException(
        'Something went wrong on the server${status != null ? ' ($status)' : ''}.');
  }

  String? _detailMessage(Object? data) {
    if (data is Map && data['detail'] != null) {
      final detail = data['detail'];
      if (detail is Map && detail['message'] is String) {
        return detail['message'] as String;
      }
      if (detail is String) return detail;
    }
    return null;
  }
}
