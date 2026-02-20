import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/data/services/gemini_service.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_chat/core/networking/failuer.dart';

abstract class ChatRepository {
  Future<Either<Failure, MessageModel>> sendMessage(String message);
}

class GeminiRepoImpl implements ChatRepository {
  final GeminiService geminiServices;

  GeminiRepoImpl({required this.geminiServices});

  @override
  Future<Either<Failure, MessageModel>> sendMessage(String message) async {
    final result = await geminiServices.sendMessage(message);

    return result.fold(
      (failure) => left(failure),
      (messageModel) => right(MessageModel(text: messageModel.text,
          sender: TypeOfSender.ai,
)),
    );
  }
}
