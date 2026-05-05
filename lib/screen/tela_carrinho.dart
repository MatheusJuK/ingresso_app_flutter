import 'package:flutter/material.dart';
import '../data/dados_mock.dart';
import '../models/ingresso.dart';
import '../models/item_carrinho.dart';
import '../models/pedido.dart';
import '../models/usuario.dart';

class TelaCarrinho extends StatelessWidget {
  final Usuario usuarioLogado;
  final List<ItemCarrinho> carrinho;
  final VoidCallback aoLimparCarrinho;
  final Function(ItemCarrinho) aoRemoverItem;

  const TelaCarrinho({
    super.key,
    required this.usuarioLogado,
    required this.carrinho,
    required this.aoLimparCarrinho,
    required this.aoRemoverItem,
  });

  double calcularTotal() {
    return carrinho.fold(0, (soma, item) => soma + item.subtotal);
  }

  void _finalizarCompra(BuildContext context) {
    if (carrinho.isEmpty) return;

    final novoPedido = Pedido(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      usuarioId: usuarioLogado.id,
      status: 'PAGO',
      valorTotal: calcularTotal(),
      criadoEm: DateTime.now(),
    );
    pedidosMock.add(novoPedido);

    for (final item in carrinho) {
      for (int i = 0; i < item.quantidade; i++) {
        final novoIngresso = Ingresso(
          id: 'i${DateTime.now().millisecondsSinceEpoch}$i${item.tipoIngresso.id}',
          pedidoId: novoPedido.id,
          eventoId: item.tipoIngresso.eventoId,
          usuarioId: usuarioLogado.id,
          codigoQr: 'QR-${novoPedido.id}-${item.tipoIngresso.id}-$i',
          status: 'VALIDO',
        );
        ingressosMock.add(novoIngresso);
      }
    }

    aoLimparCarrinho();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Compra Realizada!'),
          ],
        ),
        content: const Text(
          'Seus ingressos foram gerados com sucesso. Acesse a aba "Ingressos" para visualizá-los.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal();
    final totalFormatado =
        'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          if (carrinho.isNotEmpty)
            TextButton(
              onPressed: aoLimparCarrinho,
              child: const Text('Limpar'),
            ),
        ],
      ),
      body: carrinho.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Seu carrinho está vazio',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: carrinho.length,
              itemBuilder: (context, indice) {
                final item = carrinho[indice];
                final subtotalFormatado =
                    'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.confirmation_number,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(item.tipoIngresso.nome),
                    subtitle: Text('Qtd: ${item.quantidade}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          subtotalFormatado,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => aoRemoverItem(item),
                          child: Text(
                            'Remover',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: carrinho.isNotEmpty
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalFormatado,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _finalizarCompra(context),
                      icon: const Icon(Icons.payment),
                      label: const Text(
                        'Finalizar Compra',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
