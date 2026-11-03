
import 'package:flutter/material.dart';

// Primera pantalla: presentación animada de la aplicación.
class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  @override
  void initState() {
    super.initState();

    // Espera 3 segundos antes de abrir la pantalla principal.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/principal');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colores.primaryContainer,
      body: SafeArea(
        child: Center(
          // Anima la aparición del contenido.
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOut,
            builder: (context, valor, child) {
              return Opacity(
                opacity: valor,
                child: Transform.scale(
                  scale: 0.8 + (0.2 * valor),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.eco_rounded,
                  size: 105,
                  color: colores.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'AgroSalud',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colores.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enfermedades agrícolas',
                  style: TextStyle(
                    fontSize: 17,
                    color: colores.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 35),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
