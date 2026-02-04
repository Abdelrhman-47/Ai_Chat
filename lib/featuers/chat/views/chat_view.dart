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
    return Scaffold(
      bottomNavigationBar: BottomSection(onSend:_scrollToBottom,),
      appBar: const ChatAppBar(),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatSuccess || state is ChatLoading) {
            final messages = state is ChatSuccess
                ? state.messages
                : (state as ChatLoading).oldMessages;

            final isLoading = state is ChatLoading;

            return ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              // If loading, add 1 for the typing indicator
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
                );
              },
            );
          }

          if (state is ChatError) {
            log(state.message);
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
