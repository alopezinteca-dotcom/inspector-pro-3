import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class PhotoGallery extends StatelessWidget {
  final List<Map<String, dynamic>> photos;
  final Function(LatLng) onJump;
  final Function(int) onDelete;

  const PhotoGallery({
    super.key,
    required this.photos,
    required this.onJump,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay fotos → mensaje centrado
    if (photos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "No hay fotos recientes.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (ctx, i) {
        final f = photos[i];
        final date = DateTime.parse(f['timestamp']);
        final path = f['photo_path'];

        return ListTile(
          leading: (path != null && File(path).existsSync())
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(path),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.broken_image),

          title: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(date),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          subtitle: Text(
            "Lat: ${f['lat'].toStringAsFixed(7)}\nLng: ${f['lng'].toStringAsFixed(7)}",
            style: const TextStyle(fontSize: 12),
          ),

          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(i),
          ),

          onTap: () {
            final p = LatLng(f['lat'], f['lng']);
            onJump(p);
          },
        );
      },
    );
  }
}
