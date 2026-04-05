import 'package:flutter/services.dart';

class LocationChannel {
  static const MethodChannel _channel =
      MethodChannel('mock_location_channel');

  /// Obtiene texto compartido desde otra app (Google Maps, WhatsApp, etc.)
  Future<String?> getSharedText() async {
    try {
      return await _channel.invokeMethod('getSharedText');
    } catch (_) {
      return null;
    }
  }

  /// Inicia la simulación nativa de localización con coordenadas fijas.
  Future<String> startMocking(String lat, String lng) async {
    try {
      await _channel.invokeMethod('startMocking', {
        'lat': lat,
        'lng': lng,
      });
      return "SUCCESS";
    } on PlatformException catch (e) {
      return e.message ?? "ERROR";
    } catch (_) {
      return "ERROR";
    }
  }

  /// Detiene el servicio nativo de ubicación simulada.
  Future<bool> stopMocking() async {
    try {
      await _channel.invokeMethod('stopMocking');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Abre los ajustes de hora del sistema (Android).
  Future<bool> openTimeSettings() async {
    try {
      await _channel.invokeMethod('openTimeSettings');
      return true;
    } catch (_) {
      return false;
    }
  }
}
