import 'dart:developer';
import 'package:ai_chat/featuers/chat/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/cubit/cubit/chat_state.dart';
import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/widgets/bottom_section.dart';
import 'package:ai_chat/featuers/chat/widgets/chat_app_bar.dart';
import 'package:ai_chat/featuers/chat/widgets/message_item.dart';
import 'package:ai_chat/featuers/chat/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ChatAppBar(),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  late final List<MessageModel> messages;
                  final bool isLoading = state is ChatLoading;

                  if (state is ChatSuccess) {
                    messages = state.messages;
                  } else if (state is ChatLoading) {
                    messages = state.oldMessages;
                  } else if (state is ChatError) {
                    messages = state.messages;
                  } else {
                    messages = [];
                  }

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isLoading && index == 0) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: TypingIndicator(),
                        );
                      }

                      final itemIndex = isLoading ? index - 1 : index;
                      final msg = messages[messages.length - 1 - itemIndex];

                      return ChatBubble(
                        text: msg.text,
                        isUser: msg.sender == TypeOfSender.user,
                        isError: msg.isError,
                        onResend: msg.isError
                            ? () {
                                context.read<ChatCubit>().retryMessage(msg);
                                _scrollToBottom();
                              }
                            : null,
                      );
                    },
                  );
                },
              ),
            ),

            BottomSection(onSend: _scrollToBottom),
          ],
        ),
      ),
    );
  }
}
