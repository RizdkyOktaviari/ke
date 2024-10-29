class ChatMessage {
  final String message;
  final bool isAdmin;
  final String time;

  ChatMessage({
    required this.message,
    required this.isAdmin,
    required this.time,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      time: json['time'] ?? DateTime.now().toString().substring(11, 16),
    );
  }
}
