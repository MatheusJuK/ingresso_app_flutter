import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/api_response.dart';
import 'package:ingresso_app_flutter/routes/app_routes.dart';
import 'package:ingresso_app_flutter/services/events_service.dart';
import '../models/item_carrinho.dart';
import '../models/usuario.dart';
import '../models/evento.dart';
import '../widgets/cartao_evento.dart';

class TelaHome extends StatefulWidget {
  final Usuario usuarioLogado;
  final List<ItemCarrinho> carrinho;
  final Function(ItemCarrinho) aoAdicionarAoCarrinho;

  const TelaHome({
    super.key,
    required this.usuarioLogado,
    required this.carrinho,
    required this.aoAdicionarAoCarrinho,
  });

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  late EventsService _eventsService;
  Future<List<EventoResponse>>? _eventosFuture;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _eventsService = EventsService(apiClient);

    setState(() {
      _eventosFuture = _eventsService.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<EventoResponse>>(
        future: _eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar eventos: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _eventosFuture = _eventsService.getAllEvents();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final eventos = snapshot.data ?? [];
          if (eventos.isEmpty) {
            return const Center(child: Text('Nenhum evento disponível.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: eventos.length,
            itemBuilder: (context, indice) {
              final evento = eventos[indice];
              // Converte EventoResponse para Evento (modelo local)
              final eventoLocal = Evento(
                id: evento.id,
                titulo: evento.titulo,
                descricao: evento.descricao,
                dataInicio: evento.dataInicio,
                dataFim: evento.dataFim,
                status: evento.status,
                local: evento.local,
                organizadorId: evento.organizador.id,
              );

              return CartaoEvento(
                evento: eventoLocal,
                aoClicar: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detalheEvento,
                    arguments: DetalheEventoRouteArgs(
                      eventoId: evento.id,
                      evento: eventoLocal,
                      carrinho: widget.carrinho,
                      aoAdicionarAoCarrinho: widget.aoAdicionarAoCarrinho,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
