import 'package:flutter/material.dart';

class TicketDivider extends StatelessWidget {
  final Color color;

  const TicketDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // bolinha da esquerda
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),

        // linha tracejada do meio
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 6.0;
              const dashSpace = 4.0;
              final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
                  .floor();

              return Row(
                children: List.generate(dashCount, (_) {
                  return Container(
                    width: dashWidth,
                    height: 1,
                    margin: const EdgeInsets.only(left: dashSpace),
                    color: Colors.white.withValues(alpha: 0.1),
                  );
                }),
              );
            },
          ),
        ),

        // bolinha da direita
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
