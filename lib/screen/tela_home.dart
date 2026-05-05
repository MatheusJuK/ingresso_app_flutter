import 'package:flutter/material.dart';
import '../data/dados_mock.dart';
import '../models/item_carrinho.dart';
import '../models/usuario.dart';
import '../widgets/cartao_evento.dart';
import 'tela_detalhe_evento.dart';

class TelaHome extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Eventos', style: TextStyle(fontSize: 20)),
            Text(
              'Olá, ${usuarioLogado.nome.split(' ').first}!',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body:
          eventosMock.isEmpty
              ? const Center(child: Text('Nenhum evento disponível.'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: eventosMock.length,
                itemBuilder: (context, indice) {
                  final evento = eventosMock[indice];
                  return CartaoEvento(
                    evento: evento,
                    aoClicar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => TelaDetalheEvento(
                                evento: evento,
                                carrinho: carrinho,
                                aoAdicionarAoCarrinho: aoAdicionarAoCarrinho,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}