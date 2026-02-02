import 'package:ai_chat/core/networking/failuer.dart';
import 'package:dio/dio.dart';

class FailureHandler {
  static Failure handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        return _handleResponseError(e.response);
      
      case DioExceptionType.cancel:
        return UnknownFailure('Request was cancelled');
      
      case DioExceptionType.connectionError:
        return NetworkFailure('No internet connection. Please check your network.');
      
      case DioExceptionType.badCertificate:
        return ServerFailure('SSL certificate verification failed');
      
      case DioExceptionType.unknown:
      default:
        return UnknownFailure('Unexpected error occurred: ${e.message}');
    }
  }

  static Failure _handleResponseError(Response? response) {
    if (response == null) {
      return ServerFailure('Server error occurred');
    }

    switch (response.statusCode) {
      case 400:
        return BadRequestFailure(
          response.data['message'] ?? 'Bad request'
        );
      case 401:
        return UnauthorizedFailure(
          response.data['message'] ?? 'Unauthorized access'
        );
      case 404:
        return NotFoundFailure(
          response.data['message'] ?? 'Resource not found'
        );
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          response.data['message'] ?? 'Server error occurred'
        );
      default:
        return ServerFailure(
          'Server error with status code: ${response.statusCode}'
        );
    }
  }

  static Failure handleException(Exception e) {
    if (e is DioException) {
      return handleDioException(e);
    }
    return UnknownFailure('An unexpected error occurred: ${e.toString()}');
  }
}