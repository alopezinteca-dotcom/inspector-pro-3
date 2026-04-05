import 'dart:math';
import 'package:latlong2/latlong.dart';

class ValidationService {
  // Límite máximo de velocidad permitida (120 km/h)
  static const double maxSpeedKmh = 120.0;

  /// Calcula la distancia entre dos puntos (Haversine)
  static double _distance(LatLng p1, LatLng p2) {
    const R = 6371e3; // Radio de la Tierra en metros

    final phi1 = p1.latitude * pi / 180;
    final phi2 = p2.latitude * pi / 180;
    final dPhi = (p2.latitude - p1.latitude) * pi / 180;
    final dLambda = (p2.longitude - p1.longitude) * pi / 180;

    final a = sin(dPhi / 2) * sin(dPhi / 2) +
        cos(phi1) * cos(phi2) *
            sin(dLambda / 2) * sin(dLambda / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // distancia en metros
  }

  /// Comprueba si entre dos puntos hay un salto "ilógico" (>120 km/h)
  static String? jump(LatLng p1, DateTime t1, LatLng p2) {
    final d = _distance(p1, p2); // metros
    final secs = DateTime.now().difference(t1).inSeconds.toDouble();

    if (secs <= 0 || d < 5) return null; // movimientos pequeños → ignorar

    final v = (d / secs) * 3.6; // m/s → km/h

    if (v > maxSpeedKmh) {
      return "⚠️ Salto de ${d.toStringAsFixed(0)}m\nVelocidad: ${v.toStringAsFixed(0)} km/h";
    }

    return null;
  }

  /// Comprueba si la coordenada está dentro de España (rango aprox.)
  static String? spain(LatLng p) {
    if (p.latitude < 35.0 ||
        p.latitude > 44.0 ||
        p.longitude < -10.0 ||
        p.longitude > 5.0) {
      return "⚠️ Coordenada fuera de España.";
    }
    return null;
  }
}
