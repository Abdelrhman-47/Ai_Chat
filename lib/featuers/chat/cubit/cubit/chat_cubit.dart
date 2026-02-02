import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart' show ChatRepository;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;

  ChatCubit({required this.chatRepository}) : super(ChatInitial());

  final List<MessageModel> _messages = [];

  Future<void> sendMessage(String text) async {
    // 1️⃣ أضف رسالة اليوزر فورًا
    _messages.add(MessageModel(text: text));
    emit(ChatSuccess(List.from(_messages)));

    // 2️⃣ Loading (اختياري لو عايز typing indicator)
    emit(ChatLoading());

    // 3️⃣ Call API
    final result = await chatRepository.sendMessage(text);

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (aiMessage) {
        _messages.add(aiMessage);
        emit(ChatSuccess(List.from(_messages)));
      },
    );
  }
}
