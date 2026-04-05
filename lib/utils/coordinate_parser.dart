import 'package:latlong2/latlong.dart';
import 'utm_parser.dart';
import 'dms_parser.dart';

class CoordinateParser {
  LatLng? _parseDecimal(String input) {
    try {
      final RegExp decimalRegExp = RegExp(r'(-?\d+\.\d+)[^\d-]+(-?\d+\.\d+)');
      final match = decimalRegExp.firstMatch(input.replaceAll(',', '.'));
      if (match != null) {
        return LatLng(
          double.parse(match.group(1)!),
          double.parse(match.group(2)!),
        );
      }
    } catch (_) {}
    return null;
  }

  LatLng? _parseUTM(String input) {
    return UTMParser.parseUTM(input);
  }

  LatLng? _parseDMS(String input) {
    return DMSParser.parseDMS(input);
  }

  LatLng? parseAuto(String input) {
    if (input.trim().isEmpty) return null;

    final dec = _parseDecimal(input);
    if (dec != null) return dec;

    final dms = _parseDMS(input);
    if (dms != null) return dms;

    final utm = _parseUTM(input);
    if (utm != null) return utm;

    return null;
  }
}
