class Pedido {
  final String id;
  final String usuarioId;
  final String status;
  final double valorTotal;
  final DateTime criadoEm;
 
  Pedido({
    required this.id,
    required this.usuarioId,
    required this.status,
    required this.valorTotal,
    required this.criadoEm,
  });
}
 