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
    final selecionado = quantidade > 0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      scale: selecionado ? 1.015 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selecionado
              ? Theme.of(context).colorScheme.primaryContainer.withAlpha(115)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado
                ? Theme.of(context).colorScheme.primary.withAlpha(140)
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          boxShadow: [
            if (selecionado)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(30),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1,
                          child: child,
                        ),
                      );
                    },
                    child: selecionado
                        ? Container(
                            key: const ValueKey('selecionado'),
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Selecionado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(
                            key: ValueKey('nao-selecionado'),
                          ),
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '$quantidade',
                    key: ValueKey(quantidade),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: quantidade < tipoIngresso.quantidadeDisponivel
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
