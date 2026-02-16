import 'package:ai_chat/featuers/chat/data/model/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<MessageModel> oldMessages;
  const ChatLoading(this.oldMessages);
  @override
  List<Object?> get props => [oldMessages];
}

class ChatSuccess extends ChatState {
  final List<MessageModel> messages;

  const ChatSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final List<MessageModel> messages;

  const ChatError(this.messages);

  @override
  List<Object?> get props => [messages];
}
