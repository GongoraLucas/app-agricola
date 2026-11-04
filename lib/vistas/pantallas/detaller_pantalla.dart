import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelos/enfermedad_modelo.dart';
import '../../viewmodels/agricola_viewmodel.dart';
import '../widgets/imagen_zoom.dart';
import '../widgets/sintoma.dart';

class DetallePantalla extends StatefulWidget {
  const DetallePantalla({super.key});

  @override
  State<DetallePantalla> createState() => _DetallePantallaState();
}

class _DetallePantallaState extends State<DetallePantalla> {
  final _paginas = PageController();

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _deslizar(int direccion, int cantidad) {
    final actual = _paginas.page?.round() ?? 0;
    final destino = (actual + direccion).clamp(0, cantidad - 1);
    _paginas.animateToPage(
      destino,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento is! EnfermedadModelo) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de enfermedad')),
        body: const Center(
          child: Text('Selecciona una enfermedad de la lista.'),
        ),
      );
    }

    final enfermedad = argumento;
    final vm = context.watch<AgricolaViewModel>();
    final colores = Theme.of(context).colorScheme;
    final imagenes = enfermedad.imagenesSintomas;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F2),
      appBar: AppBar(
        title: Text(enfermedad.nombre),
        backgroundColor: colores.primaryContainer,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (imagenes.isEmpty)
              const SizedBox(
                height: 240,
                child: Center(child: Text('No hay imágenes disponibles.')),
              )
            else ...[
              SizedBox(
                height: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: PageView.builder(
                    controller: _paginas,
                    // ImagenZoom distingue un dedo (deslizar) de dos (zoom).
                    // Así ambos gestos no compiten por la misma imagen.
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: imagenes.length,
                    onPageChanged: (indice) =>
                        context.read<AgricolaViewModel>().cambiarImagen(indice),
                    itemBuilder: (context, indice) => ImagenZoom(
                      key: ValueKey('$indice-${vm.imagenActual}'),
                      imagen: imagenes[indice],
                      onZoom: (ampliada) => context
                          .read<AgricolaViewModel>()
                          .cambiarVisualizacion(ampliada),
                      onDeslizar: (direccion) =>
                          _deslizar(direccion, imagenes.length),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Imagen ${vm.imagenActual + 1} de ${imagenes.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                vm.ampliada ? 'Imagen ampliada' : 'Imagen normal',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Desliza con un dedo para cambiar de imagen. '
                'Separa o junta dos dedos para ampliar o reducir.',
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Síntomas principales',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (final texto in enfermedad.sintomas)
                    Sintoma(texto: texto),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
