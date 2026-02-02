import 'dart:developer';

import 'package:ai_chat/featuers/chat/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/cubit/cubit/chat_state.dart';
import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/widgets/chat_app_bar.dart';
import 'package:ai_chat/featuers/chat/widgets/message_item.dart';
import 'package:ai_chat/featuers/chat/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "Write your message",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_messageController.text.isNotEmpty) {
                    BlocProvider.of<ChatCubit>(
                      context,
                    ).sendMessage(_messageController.text);
                    _messageController.clear();
                    _scrollToBottom();
                  }
                  _focusNode.unfocus();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  radius: 24.sp,
                  child: SvgPicture.asset("assets/svgs/send.svg"),
                ),
              ),
            ],
          ),
        ),
      ),
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
