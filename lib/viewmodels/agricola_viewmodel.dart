import 'package:flutter/material.dart';
import '../modelos/enfermedad_modelo.dart';

class AgricolaViewModel extends ChangeNotifier {
  EnfermedadModelo? enfermedadSeleccionada;
  int imagenActual = 0;
  bool ampliada = false;

  final List<EnfermedadModelo> enfermedades = [
    EnfermedadModelo(
      nombre: 'Roya del café',
      imagen: 'https://picsum.photos/seed/roya/400/300',
      sintomas: [
        'Manchas amarillas en las hojas',
        'Polvo anaranjado en el envés',
        'Caída de hojas',
      ],
      imagenesSintomas: [
        'https://picsum.photos/seed/roya1/400/300',
        'https://picsum.photos/seed/roya2/400/300',
        'https://picsum.photos/seed/roya3/400/300',
      ],
    ),
    EnfermedadModelo(
      nombre: 'Tizón tardío',
      imagen: 'https://picsum.photos/seed/tizon/400/300',
      sintomas: [
        'Manchas cafés en las hojas',
        'Lesiones oscuras en el tallo',
        'Pudrición del fruto',
      ],
      imagenesSintomas: [
        'https://picsum.photos/seed/tizon1/400/300',
        'https://picsum.photos/seed/tizon2/400/300',
        'https://picsum.photos/seed/tizon3/400/300',
      ],
    ),
    EnfermedadModelo(
      nombre: 'Sigatoka negra',
      imagen: 'https://picsum.photos/seed/sigatoka/400/300',
      sintomas: [
        'Rayas negras en las hojas',
        'Secado de la hoja',
        'Maduración prematura del fruto',
      ],
      imagenesSintomas: [
        'https://picsum.photos/seed/sigatoka1/400/300',
        'https://picsum.photos/seed/sigatoka2/400/300',
        'https://picsum.photos/seed/sigatoka3/400/300',
      ],
    ),
  ];

  void seleccionarEnfermedad(EnfermedadModelo enfermedad) {
    enfermedadSeleccionada = enfermedad;
    imagenActual = 0;
    ampliada = false;
    notifyListeners();
  }

  void cambiarImagen(int indice) {
    imagenActual = indice;
    ampliada = false;
    notifyListeners();
  }

  void cambiarVisualizacion(bool valor) {
    if (ampliada == valor) return;
    ampliada = valor;
    notifyListeners();
  }
}
