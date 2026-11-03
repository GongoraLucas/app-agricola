import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Agricola',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/': (context) => const Placeholder(),
        '/inicio': (context) => const Placeholder(),
        '/principal': (context) => const Placeholder(),
        '/detalle': (context) => const Placeholder(),
      },
    );
  }
}
