import 'package:dio/dio.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import '../models/ingresso.dart';

class TicketsService {
  final ApiClient _apiClient;

  TicketsService(this._apiClient);

  Future<List<Ingresso>> getUserTickets({String? usuarioId}) async {
    DioException? lastError;
    try {
      final response = await _apiClient.get<List<dynamic>>('/users/tickets');

      if (response.statusCode == 200 && response.data != null) {
        final tickets = (response.data as List<dynamic>)
            .map((e) => Ingresso.fromJson(e as Map<String, dynamic>))
            .toList();

        if (usuarioId == null || usuarioId.isEmpty) {
          return tickets;
        }

        return tickets
            .where((ticket) => ticket.usuarioId == usuarioId)
            .toList();
      }
    } on DioException catch (e) {
      lastError = e;
      final status = e.response?.statusCode;
      if (status != 404 && status != 405) {
        rethrow;
      }
    }

    if (lastError != null) {
      throw (lastError.message ?? 'Erro ao buscar ingressos');
    }

    return [];
  }
}
