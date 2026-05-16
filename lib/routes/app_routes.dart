import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/models/evento.dart';
import 'package:ingresso_app_flutter/models/item_carrinho.dart';
import 'package:ingresso_app_flutter/models/usuario.dart';
import 'package:ingresso_app_flutter/screen/tela_cadastro.dart';
import 'package:ingresso_app_flutter/screen/tela_detalhe_evento.dart';
import 'package:ingresso_app_flutter/screen/tela_eventos_salvos.dart';
import 'package:ingresso_app_flutter/screen/tela_login.dart';
import 'package:ingresso_app_flutter/screen/tela_principal.dart';

class AppRoutes {
  static const login = '/';
  static const cadastro = '/cadastro';
  static const principal = '/principal';
  static const detalheEvento = '/eventos/detalhe';
  static const eventosSalvos = '/eventos-salvos';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const TelaLogin());
      case cadastro:
        return MaterialPageRoute(builder: (_) => const TelaCadastro());
      case principal:
        final args = settings.arguments as PrincipalRouteArgs;
        return MaterialPageRoute(
          builder: (_) => TelaPrincipal(usuarioLogado: args.usuarioLogado),
        );
      case detalheEvento:
        final args = settings.arguments as DetalheEventoRouteArgs;
        return MaterialPageRoute(
          builder: (_) => TelaDetalheEvento(
            eventoId: args.eventoId,
            evento: args.evento,
            carrinho: args.carrinho,
            aoAdicionarAoCarrinho: args.aoAdicionarAoCarrinho,
          ),
        );
      case eventosSalvos:
        return MaterialPageRoute(builder: (_) => const TelaEventosSalvos());
      default:
        return MaterialPageRoute(builder: (_) => const TelaLogin());
    }
  }
}

class PrincipalRouteArgs {
  final Usuario usuarioLogado;

  const PrincipalRouteArgs({required this.usuarioLogado});
}

class DetalheEventoRouteArgs {
  final String eventoId;
  final Evento evento;
  final List<ItemCarrinho> carrinho;
  final void Function(ItemCarrinho item) aoAdicionarAoCarrinho;

  const DetalheEventoRouteArgs({
    required this.eventoId,
    required this.evento,
    required this.carrinho,
    required this.aoAdicionarAoCarrinho,
  });
}
