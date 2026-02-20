import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;

  ChatCubit({required this.chatRepository}) : super(ChatInitial());

  Future<void> sendMessage(String text) async {
    emit(ChatLoading());

    final result = await chatRepository.sendMessage(text);

    result.fold(
      (failure) {
        emit(ChatError());
      },
      (aiMessage) {
        emit(ChatSuccess(aiMessage));
      },
    );
  }
}
