class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final String status;
  final String createdAt;
  final String updatedAt;
  final UserInfo sender;
  final UserInfo receiver;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    required this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      content: json['content'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      sender: UserInfo.fromJson(json['sender'] ?? {}),
      receiver: UserInfo.fromJson(json['receiver'] ?? {}),
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String username;
  final String role;

  UserInfo({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class MessageResponse {
  final bool status;
  final int code;
  final String message;
  final List<Message> data;

  MessageResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    List<Message> messages = [];
    if (json['data'] != null) {
      messages = (json['data'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList();
    }

    return MessageResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: messages,
    );
  }
}