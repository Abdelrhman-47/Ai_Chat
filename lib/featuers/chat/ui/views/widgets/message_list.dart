import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/erorr_bubble.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/message_item.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isLoading;
  final ScrollController controller;
  final void Function(int messageIndex) onRetry;

  const MessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.controller,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: controller,
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
        final msgIndex = messages.length - 1 - itemIndex;
        final msg = messages[msgIndex];

        if (msg.isError) {
          return ErrorBubble(
            message: msg.text,
            onRetry: () => onRetry(msgIndex),
          );
        } else {
          return ChatBubble(
            text: msg.text,
            isUser: msg.sender == TypeOfSender.user,
          );
        }
      },
    );
  }
}
