import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart'
    show ChatRepository;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;

  ChatCubit({required this.chatRepository}) : super(ChatInitial());

  final List<MessageModel> _messages = [];

  Future<void> sendMessage(String text) async {
    _messages.add(MessageModel(text: text));
  //  emit(ChatSuccess(_messages));
    emit(ChatLoading(_messages));

    final result = await chatRepository.sendMessage(text);

    result.fold(
      (failure) {
        final userMessage = MessageModel(text: text);
        _messages.add(userMessage);
        final index = _messages.indexOf(userMessage);
        _messages[index] = userMessage.copyWith(
          isError: true,
          text: "${userMessage.text}\n\nTry again",
        );
        emit(ChatError(List.from(_messages)));
      },
      (aiMessage) {
        _messages.add(aiMessage);
        emit(ChatSuccess(_messages));
      },
    );


  }
    void retryMessage(MessageModel message) {
  final cleanText = message.text.replaceAll("\n\nTry again", "");
  final index = _messages.indexOf(message);

  _messages[index] = MessageModel(text: cleanText);
  

  emit(ChatSuccess(List.from(_messages)));
  sendMessage(cleanText);
}
}
