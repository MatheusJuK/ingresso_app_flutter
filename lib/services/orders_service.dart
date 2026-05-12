import 'package:dio/dio.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/api_response.dart';
import 'package:ingresso_app_flutter/models/auth_response.dart';

class OrdersService {
  final ApiClient _apiClient;

  OrdersService(this._apiClient);

  /// Lista todos os pedidos do usuário autenticado
  Future<List<PedidoResponse>> getOrders() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/orders');

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List<dynamic>)
            .map((e) => PedidoResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ao buscar pedidos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Busca um pedido específico pelo ID
  Future<PedidoResponse> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/orders/$orderId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return PedidoResponse.fromJson(response.data!);
      } else {
        throw Exception('Pedido não encontrado: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cria um novo pedido
  Future<PedidoResponse> createOrder({required List<OrderItem> items}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/orders',
        data: {'itens': items.map((item) => item.toJson()).toList()},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 201 && response.data != null) {
        return PedidoResponse.fromJson(response.data!);
      } else {
        throw Exception('Erro ao criar pedido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Paga um pedido
  Future<PedidoResponse> payOrder(String orderId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/orders/$orderId/pay',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PedidoResponse.fromJson(response.data!);
      } else {
        throw Exception('Erro ao pagar pedido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cancela um pedido (somente com status PENDENTE)
  Future<PedidoResponse> cancelOrder(String orderId) async {
    try {
      final response = await _apiClient.delete<Map<String, dynamic>>(
        '/orders/$orderId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'origin': 'http://localhost:3100',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PedidoResponse.fromJson(response.data!);
      } else {
        throw Exception('Erro ao cancelar pedido: ${response.statusCode}');
      }
    } on DioException catch (e) {
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

class OrderItem {
  final String tipoIngressoId;
  final int quantidade;

  OrderItem({required this.tipoIngressoId, required this.quantidade});

  Map<String, dynamic> toJson() {
    return {'tipoIngressoId': tipoIngressoId, 'quantidade': quantidade};
  }
}
