import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../utils/jitter_generator.dart';
import 'location_channel.dart';

class MockService {
  final LocationChannel ch = LocationChannel();
  final JitterGenerator jitter = JitterGenerator();
  Timer? _timer;

  /// Inicia el mock con punto fijo + jitter sutil (0.05–0.8 m).
  Future<String> start(LatLng base) async {
    // Enviar la coordenada base al servicio nativo
    final res = await ch.startMocking(
      base.latitude.toString(),
      base.longitude.toString(),
    );

    if (res != "SUCCESS") return res;

    // Jitter periódicamente cada 0.8–1.4 segundos
    _timer = Timer.periodic(
      Duration(milliseconds: 800 + Random().nextInt(600)),
      (_) {
        final dLat = jitter.getSmallDelta();
        final dLng = jitter.getSmallDelta();

        ch.startMocking(
          (base.latitude + dLat).toString(),
          (base.longitude + dLng).toString(),
        );
      },
    );

    return res;
  }

  /// Detiene completamente el mock.
  Future<void> stop() async {
    _timer?.cancel();
    await ch.stopMocking();
  }
}
