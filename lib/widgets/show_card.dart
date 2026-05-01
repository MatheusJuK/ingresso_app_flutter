import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/utils/constantes.dart';
import '../models/show.dart';
import '../utils/constantes.dart';
import '../utils/helpers.dart';
import '../screens/detalhes_show_screen.dart';
 
class ShowCard extends StatelessWidget {
  final Show show;
 
  const ShowCard({super.key, required this.show});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => ShowDetailScreen(show: show),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              _buildColoredSide(),
              _buildShowInfo(),
              _buildPrice(),
            ],
          ),
        ),
      ),
    );
  }
 
  // lado colorido com ícone do gênero
  Widget _buildColoredSide() {
    return Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            show.cor,
            show.cor.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            generoIcon(show.genero),
            color: Colors.white.withOpacity(0.9),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            show.genero.split('/').first.trim().toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
 
  // nome, local e data
  Widget _buildShowInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              show.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: textSecondary, size: 12),
                const SizedBox(width: 3),
                Text(show.local, style: const TextStyle(color: textSecondary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: textSecondary, size: 12),
                const SizedBox(width: 3),
                Text(show.data, style: const TextStyle(color: textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  // preço e seta
  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'R\$',
            style: TextStyle(
              color: accentColor.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            show.preco.toStringAsFixed(0),
            style: const TextStyle(
              color: accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Icon(Icons.arrow_forward_ios_rounded, color: textSecondary, size: 12),
        ],
      ),
    );
  }
}
 