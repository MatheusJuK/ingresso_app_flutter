import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/evento.dart';
 
class CartaoEvento extends StatelessWidget {
  final Evento evento;
  final VoidCallback aoClicar;
 
  const CartaoEvento({
    super.key,
    required this.evento,
    required this.aoClicar,
  });
 
  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');
 
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: aoClicar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.event,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              _linhaInfo(
                Icons.calendar_today,
                formatoData.format(evento.dataInicio),
              ),
              const SizedBox(height: 6),
              _linhaInfo(Icons.location_on, evento.local),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _linhaInfo(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}