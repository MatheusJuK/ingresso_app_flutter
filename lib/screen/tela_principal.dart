import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/core/api_client.dart';
import 'package:ingresso_app_flutter/services/auth_service.dart';
import 'package:ingresso_app_flutter/widgets/app_bar_personalizada.dart';
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
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _inicializarServicos();
  }

  Future<void> _inicializarServicos() async {
    final apiClient = await ApiClient.create();
    _authService = AuthService(apiClient);
  }

  void _adicionarAoCarrinho(ItemCarrinho novoItem) {
    setState(() {
      final itemExistente = _carrinho
          .where((i) => i.tipoIngresso.id == novoItem.tipoIngresso.id)
          .toList();

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

  Future<void> _fazerLogout() async {
    try {
      await _authService.signOut();
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao fazer logout: $e')));
    }
  }

  int get _quantidadeItensCarrinho =>
      _carrinho.fold(0, (soma, item) => soma + item.quantidade);

  @override
  Widget build(BuildContext context) {
    final titulos = ['Eventos', 'Carrinho', 'Pedidos', 'Ingressos'];

    Widget telaAtual;
    switch (_abaSelecionada) {
      case 0:
        telaAtual = TelaHome(
          usuarioLogado: widget.usuarioLogado,
          carrinho: _carrinho,
          aoAdicionarAoCarrinho: _adicionarAoCarrinho,
        );
        break;
      case 1:
        telaAtual = TelaCarrinho(
          usuarioLogado: widget.usuarioLogado,
          carrinho: _carrinho,
          aoLimparCarrinho: _limparCarrinho,
          aoRemoverItem: _removerItemDoCarrinho,
        );
        break;
      case 2:
        telaAtual = TelaPedidos(usuarioLogado: widget.usuarioLogado);
        break;
      case 3:
        telaAtual = TelaIngressos(usuarioLogado: widget.usuarioLogado);
        break;
      default:
        telaAtual = TelaHome(
          usuarioLogado: widget.usuarioLogado,
          carrinho: _carrinho,
          aoAdicionarAoCarrinho: _adicionarAoCarrinho,
        );
    }

    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: titulos[_abaSelecionada],
        usuarioLogado: widget.usuarioLogado,
        aoFazerLogout: _fazerLogout,
      ),
      endDrawer: DrawerPerfilUsuario(
        usuarioLogado: widget.usuarioLogado,
        aoFazerLogout: _fazerLogout,
      ),
      body: telaAtual,
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
