import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/services/events_service.dart';
import 'package:ingresso_app_flutter/services/tickets_service.dart';
import '../models/ingresso.dart';
import '../models/usuario.dart';
import '../models/api_response.dart';

class TelaIngressos extends StatefulWidget {
  final Usuario usuarioLogado;

  const TelaIngressos({super.key, required this.usuarioLogado});

  @override
  State<TelaIngressos> createState() => _TelaIngressosState();
}

class _TelaIngressosState extends State<TelaIngressos> {
  late EventsService _eventsService;
  late TicketsService _ticketsService;
  final Map<String, EventoResponse?> _eventCache = {};
  bool _carregando = true;
  List<Ingresso> _ingressos = [];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final apiClient = await ApiClient.create();
    _eventsService = EventsService(apiClient);
    _ticketsService = TicketsService(apiClient);

    try {
      _ingressos = await _ticketsService.getUserTickets(
        usuarioId: widget.usuarioLogado.id,
      );
    } catch (_) {
      _ingressos = [];
    }

    final ingressosValidos = _ingressos
        .where((ingresso) => ingresso.usuarioId == widget.usuarioLogado.id)
        .toList();

    for (final ingresso in _ingressos) {
      if (_eventCache.containsKey(ingresso.eventoId)) {
        continue;
      }

      try {
        final evt = await _eventsService.getEventById(ingresso.eventoId);
        _eventCache[ingresso.eventoId] = evt;
      } catch (_) {
        _eventCache[ingresso.eventoId] = null;
      }
    }

    _ingressos = ingressosValidos;

    if (mounted) setState(() => _carregando = false);
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'VALIDO':
        return Colors.green;
      case 'USADO':
        return Colors.orange;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _labelStatus(String status) {
    switch (status) {
      case 'VALIDO':
        return 'VÁLIDO';
      case 'USADO':
        return 'USADO';
      case 'CANCELADO':
        return 'CANCELADO';
      default:
        return status;
    }
  }

  void _abrirQrCode(BuildContext context, Ingresso ingresso) {
    final evento = _eventCache[ingresso.eventoId];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              evento?.titulo ?? 'Evento',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _corStatus(ingresso.status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labelStatus(ingresso.status),
                style: TextStyle(
                  color: _corStatus(ingresso.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 180,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ingresso.codigoQr,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingressos = _ingressos;

    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: ingressos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum ingresso encontrado',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compre ingressos na aba Eventos',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ingressos.length,
              itemBuilder: (context, indice) {
                final ingresso = ingressos[indice];
                final evento = _eventCache[ingresso.eventoId];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _abrirQrCode(context, ingresso),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.qr_code,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  evento?.titulo ?? 'Evento não encontrado',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Toque para ver QR Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _corStatus(
                                ingresso.status,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _labelStatus(ingresso.status),
                              style: TextStyle(
                                fontSize: 11,
                                color: _corStatus(ingresso.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
