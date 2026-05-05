import 'package:flutter/material.dart';
import '../models/item_carrinho.dart';
import '../models/usuario.dart';
import 'tela_home.dart';
import 'tela_carrinho.dart';
import 'tela_pedidos.dart';
import 'tela_ingressos.dart';
 
class TelaPrincipal extends StatefulWidget {
  final Usuario usuarioLogado;
 
  const TelaPrincipal({super.key, required this.usuarioLogado});
 
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}
 
class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaSelecionada = 0;
  final List<ItemCarrinho> _carrinho = [];
 
  void _adicionarAoCarrinho(ItemCarrinho novoItem) {
    setState(() {
      final itemExistente = _carrinho.where(
        (i) => i.tipoIngresso.id == novoItem.tipoIngresso.id,
      );
 
      if (itemExistente.isNotEmpty) {
        itemExistente.first.quantidade += novoItem.quantidade;
      } else {
        _carrinho.add(novoItem);
      }
    });
  }
 
  void _removerItemDoCarrinho(ItemCarrinho item) {
    setState(() {
      _carrinho.removeWhere((i) => i.tipoIngresso.id == item.tipoIngresso.id);
    });
  }
 
  void _limparCarrinho() {
    setState(() => _carrinho.clear());
  }
 
  int get _quantidadeItensCarrinho =>
      _carrinho.fold(0, (soma, item) => soma + item.quantidade);
 
  @override
  Widget build(BuildContext context) {
    final telas = [
      TelaHome(
        usuarioLogado: widget.usuarioLogado,
        carrinho: _carrinho,
        aoAdicionarAoCarrinho: _adicionarAoCarrinho,
      ),
      TelaCarrinho(
        usuarioLogado: widget.usuarioLogado,
        carrinho: _carrinho,
        aoLimparCarrinho: _limparCarrinho,
        aoRemoverItem: _removerItemDoCarrinho,
      ),
      TelaPedidos(usuarioLogado: widget.usuarioLogado),
      TelaIngressos(usuarioLogado: widget.usuarioLogado),
    ];
 
    return Scaffold(
      body: telas[_abaSelecionada],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (indice) {
          setState(() => _abaSelecionada = indice);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _quantidadeItensCarrinho > 0,
              label: Text('$_quantidadeItensCarrinho'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _quantidadeItensCarrinho > 0,
              label: Text('$_quantidadeItensCarrinho'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Carrinho',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Ingressos',
          ),
        ],
      ),
    );
  }
}