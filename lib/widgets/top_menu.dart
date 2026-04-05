import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  final VoidCallback onRealLocation;
  final VoidCallback onToggleSat;
  final bool isSatellite;
  final VoidCallback onPhoto;
  final VoidCallback onGallery;
  final VoidCallback onSettings;

  const TopMenu({
    super.key,
    required this.onRealLocation,
    required this.onToggleSat,
    required this.isSatellite,
    required this.onPhoto,
    required this.onGallery,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900]?.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: onRealLocation,
          ),
          Container(width: 1, height: 30, color: Colors.grey),

          IconButton(
            icon: Icon(
              isSatellite ? Icons.map : Icons.satellite_alt,
              color: Colors.white,
            ),
            onPressed: onToggleSat,
          ),
          Container(width: 1, height: 30, color: Colors.grey),

          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: onPhoto,
          ),
          Container(width: 1, height: 30, color: Colors.grey),

          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white),
            onPressed: onGallery,
          ),
          Container(width: 1, height: 30, color: Colors.grey),

          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: onSettings,
          ),
        ],
      ),
    );
  }
}
