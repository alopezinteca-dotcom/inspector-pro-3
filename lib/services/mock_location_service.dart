import 'package:geolocator/geolocator.dart';

class MockLocationService {
  static bool _mockEnabled = false;

  /// Comprueba de forma segura si el sistema permite ubicación
  /// SIN activar mock. Nunca crashea.
  static Future<bool> isMockAllowed() async {
    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Activa mock SOLO si el usuario lo ha pedido
  static Future<void> startMock() async {
    if (_mockEnabled) return;

    try {
      // Aquí iría tu lógica real de simulación GPS
      // (por ahora no hacemos nada peligroso)
      _mockEnabled = true;
    } catch (_) {
      _mockEnabled = false;
    }
  }

  static void stopMock() {
    _mockEnabled = false;
  }

  static bool get isEnabled => _mockEnabled;
}
