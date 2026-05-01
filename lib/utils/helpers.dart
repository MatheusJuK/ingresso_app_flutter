import 'package:flutter/material.dart';
 
IconData generoIcon(String genero) {
  final g = genero.toLowerCase();
 
  if (g.contains('rock')) return Icons.electric_bolt_rounded;
  if (g.contains('eletrônico') || g.contains('eletronico')) return Icons.graphic_eq_rounded;
  if (g.contains('sertanejo')) return Icons.music_note_rounded;
  if (g.contains('pop')) return Icons.stars_rounded;
  if (g.contains('festival')) return Icons.festival_rounded;
  if (g.contains('axé') || g.contains('axe')) return Icons.celebration_rounded;
 
  return Icons.audiotrack_rounded;
}
 