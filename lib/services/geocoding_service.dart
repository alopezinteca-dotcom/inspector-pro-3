import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../utils/coordinate_parser.dart';
import '../utils/google_extractor.dart';

class GeocodingService {
  final CoordinateParser parser = CoordinateParser();
  final GoogleExtractor extractor = GoogleExtractor();

  /// Procesa una entrada del usuario (texto, coordenadas, URL de Maps, etc.)
  Future<LatLng?> resolve(String query) async {
    final clean = query.trim();

    // -------------------------------------------------------------
    // 1) Intento directo: Decimal, DMS o UTM
    // -------------------------------------------------------------
    final direct = parser.parseAuto(clean);
    if (direct != null) return direct;

    // -------------------------------------------------------------
    // 2) Detectar URL de Google Maps
    // -------------------------------------------------------------
    final urlMatch = RegExp(r'(https?://[^\s]+)').firstMatch(clean);
    if (urlMatch != null) {
      final url = urlMatch.group(0)!;

      // Intento de extracción avanzada (anti‑Google)
      final coords = await extractor.extract(url);
      if (coords != null) return coords;
    }

    // -------------------------------------------------------------
    // 3) Fallback: Buscar como dirección normal en Nominatim
    // -------------------------------------------------------------
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?"
        "q=${Uri.encodeComponent(clean)}"
        "&format=json&limit=1",
      );

      final res = await http
          .get(url, headers: {'User-Agent': 'InspectorPro3'})
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data is List && data.isNotEmpty) {
          final lat = double.parse(data[0]['lat'].toString());
          final lon = double.parse(data[0]['lon'].toString());
          return LatLng(lat, lon);
        }
      }
    } catch (_) {}

    // Nada funcionó
    return null;
  }
}
