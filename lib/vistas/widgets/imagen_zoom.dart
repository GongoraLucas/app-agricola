import 'package:flutter/material.dart';

class ImagenZoom extends StatelessWidget {
  final String imagen;
  final Function(bool) onZoom;

  const ImagenZoom({required this.imagen, required this.onZoom, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TransformationController();

    return InteractiveViewer(
      transformationController: controller,
      minScale: 1,
      maxScale: 4,
      onInteractionEnd: (_) {
        onZoom(controller.value.getMaxScaleOnAxis() > 1);
      },
      child: Image.network(imagen, fit: BoxFit.cover),
    );
  }
}
