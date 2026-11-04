import 'package:flutter/material.dart';

class ImagenZoom extends StatefulWidget {
  final String imagen;
  final ValueChanged<bool> onZoom;
  final ValueChanged<int>? onDeslizar;

  const ImagenZoom({
    required this.imagen,
    required this.onZoom,
    this.onDeslizar,
    super.key,
  });

  @override
  State<ImagenZoom> createState() => _ImagenZoomState();
}

class _ImagenZoomState extends State<ImagenZoom> {
  final _controller = TransformationController();
  Offset _desplazamiento = Offset.zero;
  bool _multitactil = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _controller,
      minScale: 1,
      maxScale: 4,
      // Un dedo cambia de foto; no añadimos un tercer gesto de arrastre.
      panEnabled: false,
      onInteractionStart: (detalles) {
        _desplazamiento = Offset.zero;
        _multitactil = detalles.pointerCount > 1;
      },
      onInteractionUpdate: (detalles) {
        if (detalles.pointerCount > 1) _multitactil = true;
        if (!_multitactil) _desplazamiento += detalles.focalPointDelta;
        widget.onZoom(_controller.value.getMaxScaleOnAxis() > 1.01);
      },
      onInteractionEnd: (_) {
        widget.onZoom(_controller.value.getMaxScaleOnAxis() > 1.01);
        if (!_multitactil &&
            _desplazamiento.dx.abs() > 40 &&
            _desplazamiento.dx.abs() > _desplazamiento.dy.abs()) {
          widget.onDeslizar?.call(_desplazamiento.dx < 0 ? 1 : -1);
        }
      },
      child: SizedBox.expand(
        child: Image.network(
          widget.imagen,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Center(
            child: Text('No se pudo cargar la imagen. Revisa tu conexión.'),
          ),
        ),
      ),
    );
  }
}
