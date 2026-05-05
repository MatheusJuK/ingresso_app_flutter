class Ingresso {
  final String id;
  final String pedidoId;
  final String eventoId;
  final String usuarioId;
  final String codigoQr;
  final String status;
  final DateTime? utilizadoEm;
 
  Ingresso({
    required this.id,
    required this.pedidoId,
    required this.eventoId,
    required this.usuarioId,
    required this.codigoQr,
    required this.status,
    this.utilizadoEm,
  });
}
 