import 'package:ai_chat/featuers/chat/data/data_source/remote_data_source.dart';
import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:ai_chat/core/networking/failuer.dart';

abstract class ChatRepository {
  Future<Either<Failure, MessageModel>> sendMessage(String message);
}

class ChatRepositoryImpl implements ChatRepository {
  final RemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MessageModel>> sendMessage(String message) async {
    final result = await remoteDataSource.sendMessage(message);

    return result.fold(
      (failure) => left(failure),
      (messageModel) => right(MessageModel(text: messageModel.text)),
    );
  }
}
