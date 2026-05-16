import 'dart:convert';

import 'package:ingresso_app_flutter/models/evento.dart';
import 'package:ingresso_app_flutter/models/evento_salvo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventosSalvosService {
  static const String _storageKey = 'eventos_salvos';

  Future<List<EventoSalvo>> listar() async {
    final preferences = await SharedPreferences.getInstance();
    final rawItems = preferences.getStringList(_storageKey) ?? [];

    return rawItems
        .map((item) => EventoSalvo.fromMap(jsonDecode(item)))
        .toList();
  }

  Future<EventoSalvo?> buscarPorId(String eventoId) async {
    final eventos = await listar();

    for (final evento in eventos) {
      if (evento.id == eventoId) return evento;
    }

    return null;
  }

  Future<void> salvar(Evento evento) async {
    final eventos = await listar();
    final jaExiste = eventos.any((item) => item.id == evento.id);

    if (!jaExiste) {
      eventos.add(
        EventoSalvo(
          id: evento.id,
          titulo: evento.titulo,
          local: evento.local,
          salvoEm: DateTime.now(),
          observacao: '',
        ),
      );
    }

    await _persistir(eventos);
  }

  Future<void> atualizarObservacao(String eventoId, String observacao) async {
    final eventos = await listar();
    final atualizados = eventos
        .map(
          (evento) => evento.id == eventoId
              ? evento.copyWith(observacao: observacao)
              : evento,
        )
        .toList();

    await _persistir(atualizados);
  }

  Future<void> remover(String eventoId) async {
    final eventos = await listar();
    eventos.removeWhere((evento) => evento.id == eventoId);

    await _persistir(eventos);
  }

  Future<void> _persistir(List<EventoSalvo> eventos) async {
    final preferences = await SharedPreferences.getInstance();
    final rawItems = eventos.map((evento) => jsonEncode(evento.toMap()));
    await preferences.setStringList(_storageKey, rawItems.toList());
  }
}
