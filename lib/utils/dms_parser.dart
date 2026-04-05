import 'package:latlong2/latlong.dart';

class DMSParser {
  static double _toDecimal(int d, int m, double s, bool positive) {
    final dec = d + m / 60 + s / 3600;
    return positive ? dec : -dec;
  }

  static LatLng? parseDMS(String input) {
    try {
      // Formato compatible:
      // 36 12 30 N , 5 10 20 W
      //
      // Ventajas:
      // ✅ No usa grados unicode (°)
      // ✅ No usa caracteres problemáticos
      // ✅ No se rompe en GitHub
      // ✅ No se rompe en Codemagic
      final regex = RegExp(
        r'(-?\d+)[^\d]+(\d+)[^\d]+(\d+(?:\.\d+)?)[^\w]+([NnSs])'
        r'[^\d]+(-?\d+)[^\d]+(\d+)[^\d]+(\d+(?:\.\d+)?)[^\w]+([EeWw])'
      );

      final m = regex.firstMatch(input);
      if (m == null) return null;

      final latD = int.parse(m.group(1)!);
      final latM = int.parse(m.group(2)!);
      final latS = double.parse(m.group(3)!);
      final latH = m.group(4)!.toUpperCase();

      final lngD = int.parse(m.group(5)!);
      final lngM = int.parse(m.group(6)!);
      final lngS = double.parse(m.group(7)!);
      final lngH = m.group(8)!.toUpperCase();

      final lat = _toDecimal(latD, latM, latS, latH == "N");
      final lng = _toDecimal(lngD, lngM, lngS, lngH == "E");

      return LatLng(lat, lng);
    } catch (_) {
      return null;
    }
  }
}
