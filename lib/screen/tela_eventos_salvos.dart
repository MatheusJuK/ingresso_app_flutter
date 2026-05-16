import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ingresso_app_flutter/models/evento_salvo.dart';
import 'package:ingresso_app_flutter/services/eventos_salvos_service.dart';

class TelaEventosSalvos extends StatefulWidget {
  const TelaEventosSalvos({super.key});

  @override
  State<TelaEventosSalvos> createState() => _TelaEventosSalvosState();
}

class _TelaEventosSalvosState extends State<TelaEventosSalvos> {
  final EventosSalvosService _eventosSalvosService = EventosSalvosService();
  late Future<List<EventoSalvo>> _eventosFuture;

  @override
  void initState() {
    super.initState();
    _recarregarEventos();
  }

  void _recarregarEventos() {
    _eventosFuture = _eventosSalvosService.listar();
  }

  Future<void> _editarObservacao(EventoSalvo evento) async {
    final controlador = TextEditingController(text: evento.observacao);

    final novaObservacao = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(evento.titulo),
          content: TextField(
            controller: controlador,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Anotação',
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, controlador.text.trim()),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controlador.dispose();

    if (novaObservacao == null) return;

    await _eventosSalvosService.atualizarObservacao(evento.id, novaObservacao);

    if (!mounted) return;
    setState(_recarregarEventos);
    _mostrarMensagem('Evento salvo atualizado.');
  }

  Future<void> _confirmarExclusao(EventoSalvo evento) async {
    final deveExcluir = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir evento salvo?'),
          content: Text(
            'O evento "${evento.titulo}" será removido apenas dos salvos locais.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (deveExcluir != true) return;

    await _eventosSalvosService.remover(evento.id);

    if (!mounted) return;
    setState(_recarregarEventos);
    _mostrarMensagem('Evento salvo excluído.');
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos Salvos')),
      body: FutureBuilder<List<EventoSalvo>>(
        future: _eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar eventos salvos: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final eventos = snapshot.data ?? [];

          if (eventos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum evento salvo',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Salve um evento pela tela de detalhes',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              final observacao = evento.observacao.isEmpty
                  ? 'Sem anotação'
                  : evento.observacao;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.bookmark,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    evento.titulo,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(evento.local),
                        const SizedBox(height: 4),
                        Text('Anotação: $observacao'),
                        const SizedBox(height: 4),
                        Text(
                          'Salvo em ${formatoData.format(evento.salvoEm)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Opções do evento salvo',
                    onSelected: (acao) {
                      if (acao == 'editar') {
                        _editarObservacao(evento);
                      } else if (acao == 'excluir') {
                        _confirmarExclusao(evento);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'excluir',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.delete_outline),
                          title: Text('Excluir'),
                        ),
                      ),
                    ],
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
