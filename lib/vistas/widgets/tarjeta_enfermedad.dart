import 'package:flutter/material.dart';
import '../../modelos/enfermedad_modelo.dart';

class TarjetaEnfermedad extends StatelessWidget {
  final EnfermedadModelo enfermedad;
  final VoidCallback onTap;

  const TarjetaEnfermedad({required this.enfermedad, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(enfermedad.imagen, width: 60, fit: BoxFit.cover),
        title: Text(enfermedad.nombre),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
