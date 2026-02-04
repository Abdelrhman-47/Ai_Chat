import 'package:ai_chat/featuers/chat/cubit/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomSection extends StatefulWidget {
  const BottomSection({super.key, required this.onSend});
  final VoidCallback onSend;

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
    final TextEditingController _messageController = TextEditingController();
   final FocusNode _focusNode = FocusNode();
 
 

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    widget.onSend();
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
    )
      ;
  }
}