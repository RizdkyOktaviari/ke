import 'user_response.dart';

class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final User data;
  final Meta meta;
  final String dev;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
    required this.meta,
    required this.dev,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: User.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
      dev: json['dev'] ?? '',
    );
  }
}

class Meta {
  final String token;

  Meta({required this.token});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      token: json['token'] ?? '',
    );
  }
}
