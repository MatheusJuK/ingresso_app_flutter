import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dados_mock.dart';
import '../models/evento.dart';
import '../models/item_carrinho.dart';
import '../models/tipo_ingresso.dart';
import '../widgets/cartao_tipo_ingresso.dart';

class TelaDetalheEvento extends StatefulWidget {
  final Evento evento;
  final List<ItemCarrinho> carrinho;
  final Function(ItemCarrinho) aoAdicionarAoCarrinho;

  const TelaDetalheEvento({
    super.key,
    required this.evento,
    required this.carrinho,
    required this.aoAdicionarAoCarrinho,
  });

  @override
  State<TelaDetalheEvento> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<TelaDetalheEvento> {
  final Map<String, int> _quantidades = {};

  @override
  void initState() {
    super.initState();
    final tipos = buscarTiposIngressoPorEvento(widget.evento.id);
    for (final tipo in tipos) {
      _quantidades[tipo.id] = 0;
    }
  }

  void _aumentarQuantidade(TipoIngresso tipo) {
    setState(() {
      _quantidades[tipo.id] = (_quantidades[tipo.id] ?? 0) + 1;
    });
  }

  void _diminuirQuantidade(TipoIngresso tipo) {
    setState(() {
      final atual = _quantidades[tipo.id] ?? 0;
      if (atual > 0) {
        _quantidades[tipo.id] = atual - 1;
      }
    });
  }

  void _adicionarAoCarrinho() {
    int totalAdicionado = 0;

    _quantidades.forEach((tipoId, quantidade) {
      if (quantidade > 0) {
        final tipo = buscarTiposIngressoPorEvento(
          widget.evento.id,
        ).firstWhere((t) => t.id == tipoId);

        widget.aoAdicionarAoCarrinho(
          ItemCarrinho(tipoIngresso: tipo, quantidade: quantidade),
        );
        totalAdicionado += quantidade;
      }
    });

    if (totalAdicionado > 0) {
      setState(() {
        _quantidades.updateAll((key, value) => 0);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$totalAdicionado ingresso(s) adicionado(s) ao carrinho!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione ao menos um ingresso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipos = buscarTiposIngressoPorEvento(widget.evento.id);
    final formatoData = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Evento')),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.evento.titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(formatoData.format(widget.evento.dataInicio)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.evento.local)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.evento.descricao,
                  style: TextStyle(color: Colors.grey[800], height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tipos de Ingresso',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...tipos.map(
            (tipo) => CartaoTipoIngresso(
              tipoIngresso: tipo,
              quantidade: _quantidades[tipo.id] ?? 0,
              aoAumentar: () => _aumentarQuantidade(tipo),
              aoDiminuir: () => _diminuirQuantidade(tipo),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _adicionarAoCarrinho,
            icon: const Icon(Icons.shopping_cart),
            label: const Text(
              'Adicionar ao Carrinho',
              style: TextStyle(fontSize: 16),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ),
    );
  }
}