import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/models/api_response.dart';
import 'package:ingresso_app_flutter/services/orders_service.dart';
import '../models/usuario.dart';

class TelaPedidos extends StatefulWidget {
  final Usuario usuarioLogado;

  const TelaPedidos({super.key, required this.usuarioLogado});

  @override
  State<TelaPedidos> createState() => _TelaPedidosState();
}

class _TelaPedidosState extends State<TelaPedidos> {
  late OrdersService _ordersService;
  Future<List<PedidoResponse>>? _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _ordersService = OrdersService(apiClient);

    setState(() {
      _pedidosFuture = _ordersService.getOrders();
    });
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'PAGO':
        return Colors.green;
      case 'PENDENTE':
        return Colors.orange;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _pagarPedido(String pedidoId) async {
    try {
      await _ordersService.payOrder(pedidoId);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pedido pago com sucesso!')));

      setState(() {
        _pedidosFuture = _ordersService.getOrders();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao pagar pedido: $e')));
    }
  }

  Future<void> _cancelarPedido(String pedidoId) async {
    try {
      await _ordersService.cancelOrder(pedidoId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido cancelado com sucesso!')),
      );

      setState(() {
        _pedidosFuture = _ordersService.getOrders();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cancelar pedido: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat('dd/MM/yyyy', 'pt_BR');

    return Scaffold(
      body: FutureBuilder<List<PedidoResponse>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar pedidos: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pedidosFuture = _ordersService.getOrders();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final pedidos = snapshot.data ?? [];
          if (pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum pedido encontrado',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pedidos.length,
            itemBuilder: (context, indice) {
              final pedido = pedidos[indice];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pedido #${pedido.id.substring(0, 8)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _corStatus(
                                pedido.status,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pedido.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: _corStatus(pedido.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formatoData.format(pedido.criadoEm),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${pedido.quantidadeTotal} ingresso(s)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (pedido.status == 'PENDENTE') ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _cancelarPedido(pedido.id),
                                child: const Text('Cancelar'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _pagarPedido(pedido.id),
                                child: const Text('Pagar'),
                              ),
                            ),
                          ],
                        ),
                      ],
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
