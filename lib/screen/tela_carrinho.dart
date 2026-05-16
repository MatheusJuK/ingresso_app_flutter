import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/services/orders_service.dart';
import '../models/item_carrinho.dart';
import '../models/usuario.dart';

class TelaCarrinho extends StatefulWidget {
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

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  late OrdersService _ordersService;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _ordersService = OrdersService(apiClient);
  }

  double calcularTotal() {
    return widget.carrinho.fold(0, (soma, item) => soma + item.subtotal);
  }

  Future<void> _criarPedido(BuildContext context) async {
    if (widget.carrinho.isEmpty) return;

    setState(() => _carregando = true);

    try {
      final items = widget.carrinho
          .map(
            (item) => OrderItem(
              tipoIngressoId: item.tipoIngresso.id,
              quantidade: item.quantidade,
            ),
          )
          .toList();

      final pedido = await _ordersService.createOrder(items: items);
      await _ordersService.payOrder(pedido.id);

      if (!mounted) return;

      widget.aoLimparCarrinho();

      setState(() => _carregando = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Compra concluída!'),
            ],
          ),
          content: const Text(
            'Seu pedido foi pago com sucesso. Os ingressos vão aparecer na aba Ingressos e o pedido concluído ficará na aba Pedidos.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar pedido: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal();
    final totalFormatado =
        'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';

    return Scaffold(
      body: widget.carrinho.isEmpty
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
              itemCount: widget.carrinho.length,
              itemBuilder: (context, indice) {
                final item = widget.carrinho[indice];
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
                          onTap: () => widget.aoRemoverItem(item),
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
      bottomNavigationBar: widget.carrinho.isNotEmpty
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
                      onPressed: _carregando
                          ? null
                          : () => _criarPedido(context),
                      icon: _carregando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.payment),
                      label: Text(
                        _carregando ? 'Processando...' : 'Pagar Pedido',
                        style: const TextStyle(fontSize: 16),
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
