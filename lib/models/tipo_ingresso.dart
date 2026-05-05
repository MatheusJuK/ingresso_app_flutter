class TipoIngresso {
  final String id;
  final String eventoId;
  final String nome;
  final double preco;
  final int quantidadeTotal;
  final int quantidadeVendida;
  final DateTime inicioVenda;
  final DateTime fimVenda;
  final bool ativo;
 
  TipoIngresso({
    required this.id,
    required this.eventoId,
    required this.nome,
    required this.preco,
    required this.quantidadeTotal,
    required this.quantidadeVendida,
    required this.inicioVenda,
    required this.fimVenda,
    required this.ativo,
  });
 
  int get quantidadeDisponivel => quantidadeTotal - quantidadeVendida;
}