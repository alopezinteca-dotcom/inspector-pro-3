import 'package:latlong2/latlong.dart';

class DMSParser {
  static double _toDecimal(int d, int m, double s, bool positive) {
    double dec = d + m / 60 + s / 3600;
    return positive ? dec : -dec;
  }

  static LatLng? parseDMS(String input) {
    try {
      final regex = RegExp(
        r'(-?\d+)[°º\s]+(\d+)[\'\s]+(\d+(?:\.\d+)?)[\"\s]*([NnSs])?[, ]+\s*(-?\d+)[°º\s]+(\d+)[\'\s]+(\d+(?:\.\d+)?)[\"\s]*([EeWw])?',
      );

      final m = regex.firstMatch(input);
      if (m == null) return null;

      final latD = int.parse(m.group(1)!);
      final latM = int.parse(m.group(2)!);
      final latS = double.parse(m.group(3)!);
      final latH = (m.group(4) ?? "N").toUpperCase();

      final lngD = int.parse(m.group(5)!);
      final lngM = int.parse(m.group(6)!);
      final lngS = double.parse(m.group(7)!);
      final lngH = (m.group(8) ?? "E").toUpperCase();

      final lat = _toDecimal(latD, latM, latS, latH == "N");
      final lng = _toDecimal(lngD, lngM, lngS, lngH == "E");

      return LatLng(lat, lng);
    } catch (_) {
      return null;
    }
  }
}
