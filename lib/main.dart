import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/agricola_viewmodel.dart';
import 'vistas/pantallas/inicio_pantalla.dart';
import 'vistas/pantallas/principal_pantalla.dart';
import 'vistas/pantallas/detaller_pantalla.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AgricolaViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Agricola',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioPantalla(),
        '/principal': (context) => const PrincipalPantalla(),
        '/detalle': (context) => const DetallePantalla(),
      },
    );
  }
}
