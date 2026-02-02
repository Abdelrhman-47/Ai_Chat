class MessageModel {
  final String text;

  MessageModel({required this.text});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['candidates'][0]['content']['parts'][0]['text'],
    );
  }
}
