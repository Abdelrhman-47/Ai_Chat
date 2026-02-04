class MessageModel {
  final String text;
  final TypeOfSender sender;
  final bool isError;

  MessageModel({
    required this.text,
    this.sender = TypeOfSender.user,
    this.isError = false,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['candidates'][0]['content']['parts'][0]['text'],
      sender: TypeOfSender.ai,
    );
  }
}

enum TypeOfSender { user, ai }
