import 'package:ai_chat/core/networking/api_service.dart';
import 'package:ai_chat/core/networking/failuer.dart';
import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class GeminiService {
  final ApiServices _apiServices;

  GeminiService({required ApiServices apiServices})
    : _apiServices = apiServices;

  Future<Either<Failure, MessageModel>> sendMessage(String message) async {
    final body = {
      "contents": [
        {
          "parts": [
            {"text": message},
          ],
        },
      ],
    };

    try {
      final response = await _apiServices.post(
        "gemini-2.5-flash-lite:generateContent",
        body,
      );

      return right(MessageModel.fromJson(response));
    } on DioException catch (e) {
      return left(
        ServerFailure(
          e.response?.data.toString() ?? e.message ?? "Unknown error",
        ),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
