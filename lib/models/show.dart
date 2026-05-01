import 'package:flutter/material.dart';
 
class Show {
  final String id;
  final String nome;
  final String local;
  final String data;
  final double preco;
  final String genero;
  final Color cor;
 
  const Show({
    required this.id,
    required this.nome,
    required this.local,
    required this.data,
    required this.preco,
    required this.genero,
    required this.cor,
  });
}
 