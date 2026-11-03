import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/agricola_viewmodel.dart';
import '../widgets/tarjeta_enfermedad.dart';

// Segunda pantalla: lista de enfermedades agrícolas.
class PrincipalPantalla extends StatelessWidget {
  const PrincipalPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgricolaViewModel>();
    final colores = Theme.of(context).colorScheme;
    final textoTema = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F2),
      appBar: AppBar(
        title: const Text('AgroSalud'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: colores.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: colores.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 42,
                    color: colores.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enfermedades agrícolas',
                    style: textoTema.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colores.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona una enfermedad para conocer '
                        'sus síntomas, información e imágenes.',
                    style: textoTema.bodyMedium?.copyWith(
                      color: colores.onPrimaryContainer.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${vm.enfermedades.length} enfermedades disponibles',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colores.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: vm.enfermedades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final enfermedad = vm.enfermedades[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TarjetaEnfermedad(
                        enfermedad: enfermedad,
                        onTap: () {
                          context
                              .read<AgricolaViewModel>()
                              .seleccionarEnfermedad(enfermedad);

                          Navigator.pushNamed(
                            context,
                            '/detalle',
                            arguments: enfermedad,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}