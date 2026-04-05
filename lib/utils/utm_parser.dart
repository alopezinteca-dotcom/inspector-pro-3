import 'package:latlong2/latlong.dart';
import 'package:utm/utm.dart';

class UTMParser {
  static LatLng? parseUTM(String input) {
    try {
      final parts = input.trim().split(RegExp(r'\s+'));
      if (parts.length < 3) return null;

      final zoneStr = parts[0];
      final zoneNum = int.parse(
        zoneStr.replaceAll(RegExp(r'[A-Z]', caseSensitive: false), '')
      );
      final zoneLet = zoneStr.replaceAll(RegExp(r'[0-9]'), '');

      final east = double.parse(parts[1]);
      final north = double.parse(parts[2]);

      final latlon = UTM.fromUtm(
        easting: east,
        northing: north,
        zoneNumber: zoneNum,
        zoneLetter: zoneLet,
      );
      return LatLng(latlon.lat, latlon.lon);
    } catch (_) {
      return null;
    }
  }
}
