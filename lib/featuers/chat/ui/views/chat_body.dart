import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/ui/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/ui/cubit/cubit/chat_state.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/bottom_section.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
  bool _isLoading = false;
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoading) {
          _isLoading = true;
        } else if (state is ChatSuccess) {
          _messages.add(state.messages);
          _isLoading = false;
        } else if (state is ChatError) {
          if (_messages.isNotEmpty) {
            final lastIndex = _messages.length - 1;
            final lastMessage = _messages[lastIndex];
            if (lastMessage.sender == TypeOfSender.user) {
              _messages[lastIndex] = MessageModel(
                text: lastMessage.text,
                sender: TypeOfSender.user,
                isError: true,
              );
            }
          }
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: MessageList(
                messages: _messages,
                isLoading: _isLoading,
                controller: _scrollController,
                onRetry: (int msgIndex) {
                  final msg = _messages[msgIndex];
                  _messages[msgIndex] = MessageModel(
                    text: msg.text,
                    sender: TypeOfSender.user,
                    isError: false,
                  );
                  context.read<ChatCubit>().sendMessage(
                    _messages[msgIndex].text,
                  );
                  _scrollToBottom();
                },
              ),
            ),
            BottomSection(
              onSend: (MessageModel messageUser) {
                setState(() {
                  _messages.add(messageUser);
                });
                _scrollToBottom();
              },
            ),
          ],
        );
      },
    );
  }
}
