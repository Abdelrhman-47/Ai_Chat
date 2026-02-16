import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:ai_chat/featuers/chat/ui/cubit/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class BottomSection extends StatefulWidget {
const BottomSection({super.key, required this.onSend});
  final Function (MessageModel messageUser) onSend;

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

void _startListening() async {
  _speechEnabled = await _speechToText.initialize();
  if (_speechEnabled) {
    _lastWords = "";
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "en_US",
    );
    setState(() {});
  }
}


  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
     _lastWords = result.recognizedWords;

      _messageController.text = _lastWords;
    });
    if (result.finalResult) {
      _stopListening();
      setState(() {
        _speechEnabled = false;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

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
                  hintText: _speechEnabled
                      ? "Listen Now..."
                      : "Write your message",
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_speechEnabled) {
                        _stopListening();
                        setState(() {
                          _speechEnabled = false;
                        });
                      } else {
                        _startListening();
                        setState(() {
                          _speechEnabled = true;
                        });
                      }
                    },
                    icon: Icon(
                      _speechEnabled ? Icons.mic : Icons.mic_none,
                      color: _speechEnabled ? Colors.blue : Colors.grey,
                    ),
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
                  widget.onSend(MessageModel(text: _messageController.text, sender: TypeOfSender.user));
                                    _messageController.clear();

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
    );
  }
}
