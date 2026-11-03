import 'package:flutter/material.dart';

class Sintoma extends StatelessWidget {
  final String texto;

  const Sintoma({required this.texto, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check),
      title: Text(texto),
    );
  }
}
