import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart' show ChatRepository;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;

  ChatCubit({required this.chatRepository}) : super(ChatInitial());

    final List<MessageModel> _messages = [];

  Future<void> sendMessage(String text) async {
      print('1️⃣ User sent: $text');

    _messages.add(MessageModel(text: text, sender: TypeOfSender.user));
    emit(ChatSuccess(List.from(_messages)));
  print('2️⃣ Messages after user: ${_messages.length}');

    emit(ChatLoading());

    final result = await chatRepository.sendMessage(text);
      print('3️⃣ API Response: $result');


    result.fold(
      (failure) {
            print('❌ Failure happened: $failure');

        emit(ChatError(failure.message));
      },
      (aiMessage) {
        _messages.add(aiMessage);
          print('4️⃣ Messages after ai: ${_messages.length}');

        emit(ChatSuccess(List.from(_messages)));
      },
    );
  }
}
