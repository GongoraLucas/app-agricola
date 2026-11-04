import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tarea2_2/modelos/enfermedad_modelo.dart';
import 'package:tarea2_2/viewmodels/agricola_viewmodel.dart';
import 'package:tarea2_2/vistas/pantallas/detaller_pantalla.dart';

Future<AgricolaViewModel> abrirDetalle(
  WidgetTester tester, {
  EnfermedadModelo? enfermedad,
  bool sinArgumento = false,
}) async {
  final vm = AgricolaViewModel();
  final seleccion = enfermedad ?? vm.enfermedades.first;
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                vm.seleccionarEnfermedad(seleccion);
                Navigator.pushNamed(
                  context,
                  '/detalle',
                  arguments: sinArgumento ? null : seleccion,
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
        routes: {'/detalle': (_) => const DetallePantalla()},
      ),
    ),
  );
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
  addTearDown(vm.dispose);
  return vm;
}

void main() {
  testWidgets('El pellizco alcanza 4x y puede volver a 1x sin cambiar foto', (
    tester,
  ) async {
    final vm = await abrirDetalle(tester);
    final centro = tester.getCenter(find.byType(InteractiveViewer).first);
    double escala() => tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer).first)
        .transformationController!
        .value
        .getMaxScaleOnAxis();

    Future<void> pellizcar(double inicio, double fin) async {
      final izquierdo = await tester.startGesture(
        centro - Offset(inicio, 0),
        pointer: 1,
      );
      final derecho = await tester.startGesture(
        centro + Offset(inicio, 0),
        pointer: 2,
      );
      for (var paso = 1; paso <= 12; paso++) {
        final distancia = inicio + (fin - inicio) * paso / 12;
        await izquierdo.moveTo(centro - Offset(distancia, 0));
        await derecho.moveTo(centro + Offset(distancia, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await izquierdo.up();
      await derecho.up();
      await tester.pumpAndSettle();
    }

    await pellizcar(30, 160);
    expect(escala(), greaterThan(2));
    await pellizcar(30, 160);
    expect(escala(), closeTo(4, 0.01));
    expect(vm.ampliada, isTrue);
    await pellizcar(160, 30);
    await pellizcar(160, 30);
    expect(escala(), closeTo(1, 0.01));
    expect(vm.ampliada, isFalse);
    expect(vm.imagenActual, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Recibe arguments, muestra sintomas y cambia de imagen', (
    tester,
  ) async {
    final vm = await abrirDetalle(tester);
    expect(find.text(vm.enfermedades.first.nombre), findsOneWidget);
    expect(find.text(vm.enfermedades.first.sintomas.first), findsOneWidget);
    expect(find.text('Imagen 1 de 3'), findsOneWidget);
    await tester.drag(
      find.byType(InteractiveViewer).first,
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    expect(vm.imagenActual, 1);
    expect(find.text('Imagen 2 de 3'), findsOneWidget);
    await tester.drag(
      find.byType(InteractiveViewer).first,
      const Offset(220, 0),
    );
    await tester.pumpAndSettle();
    expect(vm.imagenActual, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Pellizco conserva zoom al reconstruir y cambiar foto lo reinicia',
    (tester) async {
      final vm = await abrirDetalle(tester);
      final centro = tester.getCenter(find.byType(InteractiveViewer).first);
      final dedo1 = await tester.startGesture(
        centro - const Offset(40, 0),
        pointer: 1,
      );
      final dedo2 = await tester.startGesture(
        centro + const Offset(40, 0),
        pointer: 2,
      );
      await dedo1.moveTo(centro - const Offset(70, 0));
      await dedo2.moveTo(centro + const Offset(70, 0));
      await tester.pump();
      await dedo1.moveTo(centro - const Offset(110, 0));
      await dedo2.moveTo(centro + const Offset(110, 0));
      await dedo1.up();
      await dedo2.up();
      await tester.pumpAndSettle();
      expect(vm.ampliada, isTrue);
      expect(vm.imagenActual, 0);
      final visor = tester.widget<InteractiveViewer>(
        find.byType(InteractiveViewer).first,
      );
      expect(
        visor.transformationController!.value.getMaxScaleOnAxis(),
        greaterThan(1),
      );
      expect(find.text('Imagen ampliada'), findsOneWidget);
      await tester.drag(
        find.byType(InteractiveViewer).first,
        const Offset(-220, 0),
      );
      await tester.pumpAndSettle();
      expect(vm.imagenActual, 1);
      expect(vm.ampliada, isFalse);
      await tester.drag(
        find.byType(InteractiveViewer).first,
        const Offset(220, 0),
      );
      await tester.pumpAndSettle();
      final normal = tester.widget<InteractiveViewer>(
        find.byType(InteractiveViewer).first,
      );
      expect(normal.transformationController!.value.getMaxScaleOnAxis(), 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Ruta sin arguments muestra aviso', (tester) async {
    await abrirDetalle(tester, sinArgumento: true);
    expect(find.text('Selecciona una enfermedad de la lista.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Enfermedad sin imagenes no divide ni indexa una lista vacia', (
    tester,
  ) async {
    await abrirDetalle(
      tester,
      enfermedad: EnfermedadModelo(
        nombre: 'Prueba',
        imagen: '',
        sintomas: ['Sintoma de prueba'],
        imagenesSintomas: [],
      ),
    );
    expect(find.text('No hay imágenes disponibles.'), findsOneWidget);
    expect(find.text('Sintoma de prueba'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
