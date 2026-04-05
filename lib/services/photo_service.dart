import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:latlong2/latlong.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoService {
  /// Toma una foto forense, aplica marca de agua y calcula hash SHA256.
  static Future<Map<String, dynamic>?> takeForensicPhoto(LatLng pos) async {
    try {
      final picker = ImagePicker();
      final XFile? x = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (x == null) return null;

      final file = File(x.path);
      final bytes = await file.readAsBytes();

      // HASH SHA256 COMPLETO (para auditoría)
      final digest = sha256.convert(bytes);
      final hash = digest.toString().toUpperCase();

      // Datos para estampar
      final dateStr =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
      final latStr = pos.latitude.toStringAsFixed(7);
      final lngStr = pos.longitude.toStringAsFixed(7);

      // Decodificar imagen
      img.Image? decoded = img.decodeImage(bytes);
      if (decoded != null) {
        const rectHeight = 95;

        // Capa negra semitransparente abajo
        img.fillRect(
          decoded,
          x1: 0,
          y1: decoded.height - rectHeight,
          x2: decoded.width,
          y2: decoded.height,
          color: img.ColorRgba8(0, 0, 0, 160),
        );

        // 3 líneas de marca de agua
        final w1 = "INSPECCIÓN TÉCNICA  LAT:$latStr  LNG:$lngStr";
        final w2 = "ALT:10.0m  ACC:1.0m  DATE:$dateStr";
        final w3 = "SHA256: $hash";

        img.drawString(decoded, w1,
            font: img.arial24,
            x: 20,
            y: decoded.height - 85,
            color: img.ColorRgb8(255, 255, 255));
        img.drawString(decoded, w2,
            font: img.arial24,
            x: 20,
            y: decoded.height - 55,
            color: img.ColorRgb8(255, 255, 255));
        img.drawString(decoded, w3,
            font: img.arial24,
            x: 20,
            y: decoded.height - 25,
            color: img.ColorRgb8(255, 215, 0));

        // Guardar imagen transformada
        await file.writeAsBytes(img.encodeJpg(decoded, quality: 90));
      }

      // Resultado
      return {
        'lat': pos.latitude,
        'lng': pos.longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'photo_path': file.path,
        'hash': hash,
      };
    } catch (_) {
      return null;
    }
  }

  /// Carga fotos, borra las de >7 días y actualiza almacenamiento.
  static Future<List<Map<String, dynamic>>> cleanAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("saved_photos");
    if (raw == null) return [];

    List<Map<String, dynamic>> list =
        (json.decode(raw) as List).cast<Map<String, dynamic>>();

    list.removeWhere((f) {
      try {
        final date = DateTime.parse(f["timestamp"]);
        if (DateTime.now().difference(date).inDays > 7) {
          final path = f["photo_path"];
          if (path != null && File(path).existsSync()) {
            File(path).deleteSync();
          }
          return true;
        }
      } catch (_) {}
      return false;
    });

    // Ordenar por fecha descendente
    list.sort((a, b) =>
        (b['timestamp'] as String).compareTo(a['timestamp'] as String));

    await prefs.setString("saved_photos", json.encode(list));
    return list;
  }

  /// Guarda lista completa en disco
  static Future<void> save(List<Map<String, dynamic>> photos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_photos", json.encode(photos));
  }
}
