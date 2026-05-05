import 'package:flutter/material.dart';
import '../models/tipo_ingresso.dart';
 
class CartaoTipoIngresso extends StatelessWidget {
  final TipoIngresso tipoIngresso;
  final int quantidade;
  final VoidCallback aoAumentar;
  final VoidCallback aoDiminuir;
 
  const CartaoTipoIngresso({
    super.key,
    required this.tipoIngresso,
    required this.quantidade,
    required this.aoAumentar,
    required this.aoDiminuir,
  });
 
  @override
  Widget build(BuildContext context) {
    final precoFormatado =
        'R\$ ${tipoIngresso.preco.toStringAsFixed(2).replaceAll('.', ',')}';
 
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipoIngresso.nome,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    precoFormatado,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${tipoIngresso.quantidadeDisponivel} disponíveis',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: quantidade > 0 ? aoDiminuir : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  '$quantidade',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed:
                      quantidade < tipoIngresso.quantidadeDisponivel
                          ? aoAumentar
                          : null,
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 