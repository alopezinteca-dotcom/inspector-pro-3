import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../services/geocoding_service.dart';
import '../utils/utm_parser.dart';
import '../utils/dms_parser.dart';

class CoordinateDialog extends StatefulWidget {
  final Function(LatLng) onResult;

  const CoordinateDialog({super.key, required this.onResult});

  @override
  State<CoordinateDialog> createState() => _CoordinateDialogState();
}

class _CoordinateDialogState extends State<CoordinateDialog> {
  final decLat = TextEditingController();
  final decLng = TextEditingController();

  final utmZone = TextEditingController();
  final utmEast = TextEditingController();
  final utmNorth = TextEditingController();

  final dmsCtrl = TextEditingController();
  final addrCtrl = TextEditingController();

  final GeocodingService _geo = GeocodingService();

  Future<void> _submit() async {
    LatLng? r;

    // PRIORIDAD:
    // 1) Dirección / Link
    // 2) DMS
    // 3) UTM
    // 4) Decimal

    if (addrCtrl.text.isNotEmpty) {
      r = await _geo.resolve(addrCtrl.text.trim());
    } 
    else if (dmsCtrl.text.isNotEmpty) {
      r = DMSParser.parseDMS(dmsCtrl.text.trim());
    } 
    else if (
      utmZone.text.isNotEmpty &&
      utmEast.text.isNotEmpty &&
      utmNorth.text.isNotEmpty
    ) {
      final utmStr =
          "${utmZone.text.trim()} ${utmEast.text.trim()} ${utmNorth.text.trim()}";
      r = UTMParser.parseUTM(utmStr);
    } 
    else if (decLat.text.isNotEmpty && decLng.text.isNotEmpty) {
      try {
        r = LatLng(
          double.parse(decLat.text.replaceAll(',', '.')),
          double.parse(decLng.text.replaceAll(',', '.')),
        );
      } catch (_) {}
    }

    // Si falla todo
    if (r == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo procesar la coordenada."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ajuste de 7 decimales
    final fixed = LatLng(
      double.parse(r.latitude.toStringAsFixed(7)),
      double.parse(r.longitude.toStringAsFixed(7)),
    );

    widget.onResult(fixed);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 470,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "🎯 Localizar Ubicación",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            const TabBar(
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Decimal"),
                Tab(text: "UTM"),
                Tab(text: "DMS"),
                Tab(text: "Dirección / Link"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // DECIMAL
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: decLat,
                          decoration: const InputDecoration(
                            labelText: "Latitud (36.123456)",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: decLng,
                          decoration: const InputDecoration(
                            labelText: "Longitud (-5.123456)",
                          ),
                        ),
                      ],
                    ),
                  ),

                  // UTM
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: utmZone,
                          decoration: const InputDecoration(labelText: "Zona (Ej: 30S)"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: utmEast,
                          decoration: const InputDecoration(labelText: "Easting (X)"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: utmNorth,
                          decoration: const InputDecoration(labelText: "Northing (Y)"),
                        ),
                      ],
                    ),
                  ),

                  // DMS
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: dmsCtrl,
                      decoration: const InputDecoration(
                        hintText: '36° 12\' 30" N , -5° 10\' 20" W',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),

                  // DIRECCIÓN / LINK
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: addrCtrl,
                      decoration: const InputDecoration(
                        hintText: "Calle, ciudad o enlace de Google Maps",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                  child: const Text(
                    "ENVIAR AL MAPA",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
