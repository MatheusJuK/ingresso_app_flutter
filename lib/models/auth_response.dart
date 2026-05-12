class SignUpResponse {
  final String token;
  final UserData user;

  SignUpResponse({required this.token, required this.user});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      token: json['token'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class SignInResponse {
  final bool redirect;
  final String token;
  final UserData user;

  SignInResponse({
    required this.redirect,
    required this.token,
    required this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      redirect: json['redirect'] as bool,
      token: json['token'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserData {
  final String id;
  final String cpf;
  final String name;
  final String email;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserData({
    required this.id,
    required this.cpf,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      cpf: json['cpf'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpf': cpf,
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class SessionResponse {
  final UserData? user;
  final SessionData? session;

  SessionResponse({this.user, this.session});

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      user: json['user'] != null
          ? UserData.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      session: json['session'] != null
          ? SessionData.fromJson(json['session'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SessionData {
  final DateTime expiredAt;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ipAdress;
  final String userAgent;
  final String userId;
  final String id;

  SessionData({
    required this.expiredAt,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    required this.ipAdress,
    required this.userAgent,
    required this.userId,
    required this.id,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ipAdress: json['ipAdress'] as String,
      userAgent: json['userAgent'] as String,
      userId: json['userId'] as String,
      id: json['id'] as String,
    );
  }
}

class SignOutResponse {
  final bool success;

  SignOutResponse({required this.success});

  factory SignOutResponse.fromJson(Map<String, dynamic> json) {
    return SignOutResponse(success: json['success'] as bool);
  }
}

class ErrorResponse {
  final String name;
  final int statusCode;
  final String code;
  final String message;
  final String timestamp;
  final Map<String, dynamic> details;
  final String path;

  ErrorResponse({
    required this.name,
    required this.statusCode,
    required this.code,
    required this.message,
    required this.timestamp,
    required this.details,
    required this.path,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      name: json['name'] as String,
      statusCode: json['statusCode'] as int,
      code: json['code'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      details: json['details'] as Map<String, dynamic>? ?? {},
      path: json['path'] as String? ?? '',
    );
  }
}
