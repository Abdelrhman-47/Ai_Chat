import 'package:ai_chat/featuers/chat/ui/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/ui/cubit/cubit/chat_state.dart';
import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/bottom_section.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/chat_app_bar.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/erorr_bubble.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/message_item.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ChatAppBar(),
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            // if (state is ChatSuccess) {
            //   _messages = state.messages;
            //   _isLoading = false;
            // } else if (state is ChatLoading) {
            //   _messages = state.oldMessages;
            //   _isLoading = true;
            // } else if (state is ChatError) {
            //   _messages = state.messages;
            //   _isLoading = false;
            // }
            if (state is ChatLoading) {
              _isLoading = true;
            }
            if (state is ChatSuccess) {
              _messages.add(state.messages);
              _isLoading = false;
            }
           else if (state is ChatError) {
            
                // Mark the last user message as error
                if (_messages.isNotEmpty) {
                  final lastIndex = _messages.length - 1;
                  final lastMessage = _messages[lastIndex];
                  
                  // Only mark as error if it's a user message
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
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == 0) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: TypingIndicator(),
                        );
                      }

                      final itemIndex = _isLoading ? index - 1 : index;
                      final msg = _messages[_messages.length - 1 - itemIndex];

                         if (msg.isError) {
                              return ErrorBubble(
                                message: msg.text,
                                onRetry: () {
                                  // Remove error flag and retry sending
                                  setState(() {
                                    final msgIndex = _messages.length - 1 - itemIndex;
                                    _messages[msgIndex] = MessageModel(
                                      text: msg.text,
                                      sender: TypeOfSender.user,
                                      isError: false,
                                    );
                                  });
                                  
                                  // Retry sending the message
                                  context.read<ChatCubit>().sendMessage(msg.text);
                                },
                              );
                            } else {
                              // Show normal chat bubble
                              return ChatBubble(
                                text: msg.text,
                                isUser: msg.sender == TypeOfSender.user,
                              );
                            }
                    },
                  ),
                ),
                BottomSection(
                  onSend: (MessageModel messageUser) {
                    _scrollToBottom();
                    _messages.add(messageUser);
                  },
                ),
              ],
            );

            // if (state is ChatError){
            //   return ErrorBubble(message: 'error', onRetry: (){});

            // }

            // return const SizedBox();
          },
        ),
      ),
    );
  }
}
