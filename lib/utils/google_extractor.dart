import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GoogleExtractor {
  // User-Agent realista para que Google no bloquee la petición
  static const Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
        ' AppleWebKit/537.36 (KHTML, like Gecko)'
        ' Chrome/120.0.0.0 Safari/537.36'
  };

  // Patrones oficiales usados por Google Maps para compartir ubicaciones
  final List<RegExp> patterns = [
    RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)'),      // @lat,lng
    RegExp(r'!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)'),  // !3dlat!4dlng
    RegExp(r'll=(-?\d+\.\d+),(-?\d+\.\d+)'),    // ll=lat,lng
    RegExp(r'center=(-?\d+\.\d+),(-?\d+\.\d+)'),// center=lat,lng
    RegExp(r'q=(-?\d+\.\d+),(-?\d+\.\d+)'),     // q=lat,lng
  ];

  // Captura floja (fallback) de pares lat/lng en cualquier HTML/JS
  final RegExp loosePair =
      RegExp(r'(-?\d{1,2}\.\d+)[^\d-]+(-?\d{1,3}\.\d+)');

  /// Extrae coordenadas de URLs de Google Maps, incluso con protección anti‑bots.
  Future<LatLng?> extract(String url) async {
    try {
      // Obtenemos HTML o redirección
      final res = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 6));

      // URL final y HTML decodificados
      final finalUrl = Uri.decodeFull(res.request?.url.toString() ?? url);
      final html = Uri.decodeFull(res.body);

      // 1) Buscar patrones en la URL
      for (final p in patterns) {
        final m = p.firstMatch(finalUrl);
        if (m != null) {
          return LatLng(
            double.parse(m.group(1)!),
            double.parse(m.group(2)!),
          );
        }
      }

      // 2) Buscar patrones en el HTML/JS
      for (final p in patterns) {
        final m = p.firstMatch(html);
        if (m != null) {
          return LatLng(
            double.parse(m.group(1)!),
            double.parse(m.group(2)!),
          );
        }
      }

      // 3) Fallback flojo
      final loose = loosePair.firstMatch(html);
      if (loose != null) {
        return LatLng(
          double.parse(loose.group(1)!),
          double.parse(loose.group(2)!),
        );
      }
    } catch (_) {}

    return null; // Nada encontrado
  }
}
