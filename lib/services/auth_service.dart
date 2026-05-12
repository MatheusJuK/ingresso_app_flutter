import 'package:dio/dio.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/auth_response.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  /// Faz signup do usuário
  Future<SignUpResponse> signUp({
    required String cpf,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/sign-up/email',
        data: {'cpf': cpf, 'name': name, 'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SignUpResponse.fromJson(response.data ?? {});
      } else {
        throw Exception('Erro ao fazer signup: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Faz login do usuário
  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/sign-in/email',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SignInResponse.fromJson(response.data ?? {});
      } else {
        throw Exception('Erro ao fazer login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Faz logout do usuário
  Future<SignOutResponse> signOut() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/sign-out',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SignOutResponse.fromJson(response.data ?? {});
      } else {
        throw Exception('Erro ao fazer logout: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Recupera a sessão atual
  Future<SessionResponse?> getSession() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/auth/get-session',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SessionResponse.fromJson(response.data!);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return null; // Não autenticado
      }
      throw _handleError(e);
    }
  }

  /// Tratamento de erros
  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      try {
        final error = ErrorResponse.fromJson(
          e.response?.data as Map<String, dynamic>,
        );
        return error.message;
      } catch (_) {
        return e.message ?? 'Erro desconhecido';
      }
    }
    return e.message ?? 'Erro de conexão com o servidor';
  }
}
