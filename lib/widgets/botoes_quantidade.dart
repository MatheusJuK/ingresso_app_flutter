import 'package:flutter/material.dart';

class QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final Color? activeColor;

  const QtyButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.enabled,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? (activeColor?.withValues(alpha: 0.15) ??
                    Colors.white.withValues(alpha: 0.05))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: enabled
              ? (activeColor ?? Colors.white)
              : Colors.white.withValues(alpha: 0.2),
          size: 20,
        ),
      ),
    );
  }
}
