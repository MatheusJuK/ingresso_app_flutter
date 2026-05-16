import 'package:dio/dio.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/api_response.dart';
import 'package:ingresso_app_flutter/models/auth_response.dart';

class EventsService {
  final ApiClient _apiClient;

  EventsService(this._apiClient);

  /// Lista todos os eventos
  Future<List<EventoResponse>> getEvents({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/events',
        queryParameters: {
          'page': page,
          'limit': limit,
          'offset': (page - 1) * limit,
          'take': limit,
          'pageSize': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List<dynamic>)
            .map((e) => EventoResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erro ao buscar eventos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Busca todos os eventos paginando até não existir próxima página.
  Future<List<EventoResponse>> getAllEvents({int pageSize = 100}) async {
    final eventos = <EventoResponse>[];
    final idsVistos = <String>{};

    for (var page = 1; page <= 50; page++) {
      final pagina = await getEvents(page: page, limit: pageSize);

      var adicionouAlgum = false;
      for (final evento in pagina) {
        if (idsVistos.add(evento.id)) {
          eventos.add(evento);
          adicionouAlgum = true;
        }
      }

      if (pagina.isEmpty || pagina.length < pageSize || !adicionouAlgum) {
        break;
      }
    }

    return eventos;
  }

  /// Busca um evento específico pelo ID
  Future<EventoResponse> getEventById(String eventId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/events/$eventId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return EventoResponse.fromJson(response.data!);
      } else {
        throw Exception('Evento não encontrado: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Lista os tipos de ingresso de um evento
  Future<List<TipoIngressoResponse>> getTicketsByEventId(String eventId) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/tickets/event/$eventId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List<dynamic>)
            .map(
              (e) => TipoIngressoResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Erro ao buscar ingressos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Busca um tipo de ingresso específico
  Future<TipoIngressoResponse> getTicketById(String ticketId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/tickets/$ticketId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return TipoIngressoResponse.fromJson(response.data!);
      } else {
        throw Exception('Ingresso não encontrado: ${response.statusCode}');
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
