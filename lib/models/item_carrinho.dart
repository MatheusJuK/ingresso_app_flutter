import 'tipo_ingresso.dart';
 
class ItemCarrinho {
  final TipoIngresso tipoIngresso;
  int quantidade;
 
  ItemCarrinho({
    required this.tipoIngresso,
    required this.quantidade,
  });
 
  double get subtotal => tipoIngresso.preco * quantidade;
}
 