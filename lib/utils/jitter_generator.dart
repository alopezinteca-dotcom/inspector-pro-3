import 'dart:math';

class JitterGenerator {
  final Random _rnd = Random();

  /// Genera un jitter extremadamente realista:
  /// 0.0000005° → ~0.05 m
  /// 0.0000065° → ~0.72 m
  /// NO produce desplazamientos bruscos ni movimientos irreales.
  double getSmallDelta() {
    final base = 0.0000005;      // 5e-7 (0.05 m aprox.)
    final max = 0.0000065;       // 6.5e-6 (0.72 m aprox.)
    final delta = base + _rnd.nextDouble() * max;

    // Aleatorio: positivo o negativo
    return _rnd.nextBool() ? delta : -delta;
  }
}
