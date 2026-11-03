import 'package:flutter/material.dart';

class Dato extends StatelessWidget {
  final String titulo;
  final String valor;

  const Dato({required this.titulo, required this.valor,super.key});

  @override
  Widget build(BuildContext context) {
    final colorTexto = Theme.of(context).colorScheme.onSurface;
    return ListTile(
        title: Text(titulo, style:  TextStyle(color: colorTexto )),
        trailing: Text(
          valor,
          style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
        ),
      );
  }
}