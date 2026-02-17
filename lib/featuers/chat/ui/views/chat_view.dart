import 'package:ai_chat/featuers/chat/ui/views/chat_body.dart';
import 'package:ai_chat/featuers/chat/ui/views/widgets/chat_app_bar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ChatAppBar(),
        resizeToAvoidBottomInset: true,
        body: const ChatBody(),
      ),
    );
  }
}
