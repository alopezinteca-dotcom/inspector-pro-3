import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MockControls extends StatelessWidget {
  final LatLng center;
  final bool isMocking;
  final Function(double, double) onAdjust;

  const MockControls({
    super.key,
    required this.center,
    required this.isMocking,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    // Si está mockeando → NO mostrar controles
    if (isMocking) return const SizedBox.shrink();

    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height / 2 - 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4),
          ],
        ),
        child: Column(
          children: [
            // ARRIBA
            IconButton(
              icon: const Icon(Icons.arrow_drop_up),
              onPressed: () => onAdjust(0.000009, 0),
            ),

            // IZQUIERDA / DERECHA
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () => onAdjust(
                    0,
                    -0.000009 / cos(center.latitude * pi / 180),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () => onAdjust(
                    0,
                    0.000009 / cos(center.latitude * pi / 180),
                  ),
                ),
              ],
            ),

            // ABAJO
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () => onAdjust(-0.000009, 0),
            ),
          ],
        ),
      ),
    );
  }
}
