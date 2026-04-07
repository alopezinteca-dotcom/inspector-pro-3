import 'package:flutter/material.dart';
import '../services/mock_location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoMaster'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Text(
              'Estado de simulación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              MockLocationService.isEnabled
                  ? '✅ Simulación activa'
                  : '❌ Simulación desactivada',
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                final allowed = await MockLocationService.isMockAllowed();

                if (!allowed) {
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Ubicación simulada no activada'),
                      content: const Text(
                        'Para usar simulación:\n\n'
                        '1. Activa las opciones de desarrollador\n'
                        '2. En "Aplicación de ubicación simulada"\n'
                        '   selecciona GeoMaster\n'
                        '3. Vuelve aquí y pulsa el botón otra vez',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Entendido'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                await MockLocationService.startMock();
                setState(() {});
              },
              child: const Text('Iniciar simulación'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                MockLocationService.stopMock();
                setState(() {});
              },
              child: const Text('Detener simulación'),
            ),
          ],
        ),
      ),
    );
  }
}
