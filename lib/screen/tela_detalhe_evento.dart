import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/api_response.dart';
import 'package:ingresso_app_flutter/services/events_service.dart';
import 'package:ingresso_app_flutter/services/eventos_salvos_service.dart';
import '../models/evento.dart';
import '../models/item_carrinho.dart';
import '../models/tipo_ingresso.dart';
import '../widgets/cartao_tipo_ingresso.dart';

class TelaDetalheEvento extends StatefulWidget {
  final String eventoId;
  final Evento evento;
  final List<ItemCarrinho> carrinho;
  final Function(ItemCarrinho) aoAdicionarAoCarrinho;

  const TelaDetalheEvento({
    super.key,
    required this.eventoId,
    required this.evento,
    required this.carrinho,
    required this.aoAdicionarAoCarrinho,
  });

  @override
  State<TelaDetalheEvento> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<TelaDetalheEvento> {
  final Map<String, int> _quantidades = {};
  final _controladorObservacao = TextEditingController();
  late EventsService _eventsService;
  final EventosSalvosService _eventosSalvosService = EventosSalvosService();
  Future<List<TipoIngressoResponse>>? _ingressosFuture;
  Map<String, TipoIngressoResponse> _tiposMap = {};
  bool _eventoSalvo = false;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
    _carregarEventoSalvo();
  }

  @override
  void dispose() {
    _controladorObservacao.dispose();
    super.dispose();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _eventsService = EventsService(apiClient);

    final future = _eventsService.getTicketsByEventId(widget.eventoId);
    setState(() {
      _ingressosFuture = future;
    });

    try {
      final lista = await future;
      setState(() {
        _tiposMap = {for (var t in lista) t.id: t};
      });
    } catch (_) {
      // ignore errors here; fallback will use defaults
    }
  }

  Future<void> _carregarEventoSalvo() async {
    final eventoSalvo = await _eventosSalvosService.buscarPorId(
      widget.evento.id,
    );

    if (!mounted) return;

    setState(() {
      _eventoSalvo = eventoSalvo != null;
      _controladorObservacao.text = eventoSalvo?.observacao ?? '';
    });
  }

  Future<void> _alternarEventoSalvo() async {
    if (_eventoSalvo) {
      await _eventosSalvosService.remover(widget.evento.id);
      if (!mounted) return;

      setState(() {
        _eventoSalvo = false;
        _controladorObservacao.clear();
      });
      _mostrarMensagem('Evento removido dos salvos.');
      return;
    }

    await _eventosSalvosService.salvar(widget.evento);
    if (!mounted) return;

    setState(() => _eventoSalvo = true);
    _mostrarMensagem('Evento salvo no dispositivo.');
  }

  Future<void> _atualizarObservacao() async {
    if (!_eventoSalvo) {
      await _eventosSalvosService.salvar(widget.evento);
      if (!mounted) return;
      setState(() => _eventoSalvo = true);
    }

    await _eventosSalvosService.atualizarObservacao(
      widget.evento.id,
      _controladorObservacao.text.trim(),
    );

    if (!mounted) return;
    _mostrarMensagem('Anotação atualizada.');
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  void _aumentarQuantidade(String tipoId) {
    setState(() {
      _quantidades[tipoId] = (_quantidades[tipoId] ?? 0) + 1;
    });
  }

  void _diminuirQuantidade(String tipoId) {
    setState(() {
      final atual = _quantidades[tipoId] ?? 0;
      if (atual > 0) {
        _quantidades[tipoId] = atual - 1;
      }
    });
  }

  void _adicionarAoCarrinho() {
    int totalAdicionado = 0;

    _quantidades.forEach((tipoId, quantidade) {
      if (quantidade > 0) {
        final resp = _tiposMap[tipoId];
        final tipo = resp != null
            ? TipoIngresso(
                id: resp.id,
                nome: resp.nome,
                preco: resp.preco.toDouble(),
                eventoId: resp.eventoId,
                quantidadeTotal: resp.quantidadeTotal,
                quantidadeVendida: resp.quantidadeVendida,
                inicioVenda: resp.inicioVenda,
                fimVenda: resp.fimVenda,
                ativo: resp.ativo,
              )
            : TipoIngresso(
                id: tipoId,
                nome: 'Ingresso',
                preco: 0.0,
                eventoId: widget.eventoId,
                quantidadeTotal: 0,
                quantidadeVendida: 0,
                inicioVenda: DateTime.now(),
                fimVenda: DateTime.now(),
                ativo: true,
              );

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
          content: Text(
            '$totalAdicionado ingresso(s) adicionado(s) ao carrinho!',
          ),
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
                OutlinedButton.icon(
                  onPressed: _alternarEventoSalvo,
                  icon: Icon(
                    _eventoSalvo ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  label: Text(_eventoSalvo ? 'Evento salvo' : 'Salvar evento'),
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controladorObservacao,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Anotação pessoal',
                    hintText: 'Ex: chamar amigos, comprar VIP...',
                    prefixIcon: const Icon(Icons.edit_note),
                    suffixIcon: IconButton(
                      tooltip: 'Atualizar anotação',
                      icon: const Icon(Icons.save_outlined),
                      onPressed: _atualizarObservacao,
                    ),
                  ),
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
          FutureBuilder<List<TipoIngressoResponse>>(
            future: _ingressosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Erro ao carregar ingressos: ${snapshot.error}',
                    ),
                  ),
                );
              }

              final ingressos = snapshot.data ?? [];
              if (ingressos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('Nenhum ingresso disponível.')),
                );
              }

              // Inicializa as quantidades se não existem
              for (final ingresso in ingressos) {
                _quantidades.putIfAbsent(ingresso.id, () => 0);
              }

              return Column(
                children: ingressos
                    .map(
                      (ingresso) => CartaoTipoIngresso(
                        tipoIngresso: TipoIngresso(
                          id: ingresso.id,
                          nome: ingresso.nome,
                          preco: ingresso.preco.toDouble(),
                          eventoId: ingresso.eventoId,
                          quantidadeTotal: ingresso.quantidadeTotal,
                          quantidadeVendida: ingresso.quantidadeVendida,
                          inicioVenda: ingresso.inicioVenda,
                          fimVenda: ingresso.fimVenda,
                          ativo: ingresso.ativo,
                        ),
                        quantidade: _quantidades[ingresso.id] ?? 0,
                        aoAumentar: () => _aumentarQuantidade(ingresso.id),
                        aoDiminuir: () => _diminuirQuantidade(ingresso.id),
                      ),
                    )
                    .toList(),
              );
            },
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
