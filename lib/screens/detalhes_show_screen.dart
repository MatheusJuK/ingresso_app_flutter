import 'package:flutter/material.dart';
import '../models/show.dart';
import '../utils/constantes.dart';
import '../utils/helpers.dart';
import '../widgets/info_chip.dart';
import '../widgets/botoes_quantidade.dart';
import '../widgets/ticket_separador.dart';
 
class ShowDetailScreen extends StatefulWidget {
  final Show show;
 
  const ShowDetailScreen({super.key, required this.show});
 
  @override
  State<ShowDetailScreen> createState() => _ShowDetailScreenState();
}
 
class _ShowDetailScreenState extends State<ShowDetailScreen> {
  int quantidade = 1;
 
  void _aumentar() => setState(() => quantidade++);
 
  void _diminuir() {
    if (quantidade > 1) setState(() => quantidade--);
  }
 
  double get _total => widget.show.preco * quantidade;
 
  @override
  Widget build(BuildContext context) {
    final show = widget.show;
 
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(context, show),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationAndDate(show),
                  const SizedBox(height: 24),
                  TicketDivider(color: show.cor),
                  const SizedBox(height: 24),
                  _buildPriceAndQty(show),
                  const SizedBox(height: 24),
                  _buildTotalBox(),
                  const SizedBox(height: 28),
                  _buildBuyButton(show),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  // cabeçalho com gradiente, ícone e nome do show
  Widget _buildHeader(BuildContext context, Show show) {
    return Stack(
      children: [
        // fundo degradê
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                show.cor.withOpacity(0.9),
                show.cor.withOpacity(0.4),
                bgColor,
              ],
            ),
          ),
        ),
 
        // padrão de pontinhos decorativo
        Positioned.fill(
          child: Opacity(
            opacity: 0.07,
            child: CustomPaint(painter: _DotPatternPainter()),
          ),
        ),
 
        // ícone grande no centro
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Icon(
                  generoIcon(show.genero),
                  color: Colors.white.withOpacity(0.25),
                  size: 120,
                ),
              ],
            ),
          ),
        ),
 
        // botão de voltar
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
 
        // badge do gênero (canto superior direito)
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Text(
              show.genero,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
 
        // nome do show na parte de baixo
        Positioned(
          bottom: 16,
          left: 20,
          right: 20,
          child: Text(
            show.nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
 
  // chips de local e data
  Widget _buildLocationAndDate(Show show) {
    return Row(
      children: [
        InfoChip(
          icon: Icons.location_on_rounded,
          text: show.local,
          color: show.cor,
        ),
        const SizedBox(width: 8),
        InfoChip(
          icon: Icons.calendar_today_rounded,
          text: show.data,
          color: show.cor,
        ),
      ],
    );
  }
 
  // valor do ingresso + controle de quantidade
  Widget _buildPriceAndQty(Show show) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // preço unitário
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VALOR DO INGRESSO',
              style: TextStyle(
                color: textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'R\$ ',
                    style: TextStyle(
                      color: accentColor.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: show.preco.toStringAsFixed(2),
                    style: const TextStyle(
                      color: accentColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
 
        // botões de quantidade
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              QtyButton(
                icon: Icons.remove_rounded,
                onTap: _diminuir,
                enabled: quantidade > 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$quantidade',
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              QtyButton(
                icon: Icons.add_rounded,
                onTap: _aumentar,
                enabled: true,
                activeColor: show.cor,
              ),
            ],
          ),
        ),
      ],
    );
  }
 
  // caixinha com o total
  Widget _buildTotalBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$quantidade ingresso${quantidade > 1 ? 's' : ''}',
            style: const TextStyle(color: textSecondary, fontSize: 14),
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Total: ',
                  style: TextStyle(color: textSecondary, fontSize: 14),
                ),
                TextSpan(
                  text: 'R\$ ${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  // botão de adicionar ao carrinho
  Widget _buildBuyButton(Show show) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _mostrarConfirmacao(show),
        style: ElevatedButton.styleFrom(
          backgroundColor: show.cor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_num_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              'Adicionar ao Carrinho',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  void _mostrarConfirmacao(Show show) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surfaceColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: show.cor, size: 20),
            const SizedBox(width: 10),
            Text(
              '$quantidade ingresso${quantidade > 1 ? 's' : ''} adicionado${quantidade > 1 ? 's' : ''} ao carrinho!',
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
// painter do padrão de pontinhos do cabeçalho
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    const spacing = 20.0;
 
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }
 
  @override
  bool shouldRepaint(_) => false;
}
 