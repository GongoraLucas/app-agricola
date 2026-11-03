import 'package:flutter/material.dart';

// Splash de AgroSalud: imagen del cultivo con aparición progresiva.
class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  // true: deja tiempo para tomar capturas. false: velocidad normal.
  static const bool modoCapturas = true;

  double _opacidadImagen = 0;
  double _escalaImagen = 0.90;

  @override
  void initState() {
    super.initState();
    _iniciarSplash();
  }

  Future<void> _iniciarSplash() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Primera etapa: imagen parcialmente visible para la primera captura.
    setState(() {
      _opacidadImagen = 0.65;
      _escalaImagen = 0.95;
    });

    await Future.delayed(Duration(seconds: modoCapturas ? 4 : 1));
    if (!mounted) return;

    // Segunda etapa: imagen completamente visible.
    setState(() {
      _opacidadImagen = 1;
      _escalaImagen = 1;
    });

    await Future.delayed(Duration(seconds: modoCapturas ? 4 : 2));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/principal');
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Solo la imagen se anima: los textos siempre se ven claros.
                AnimatedOpacity(
                  opacity: _opacidadImagen,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  child: AnimatedScale(
                    scale: _escalaImagen,
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/cultivo.png',
                      width: 290,
                      height: 235,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AgroSalud',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colores.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enfermedades agrícolas',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 32),
                CircularProgressIndicator(color: colores.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
