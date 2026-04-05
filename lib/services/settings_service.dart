import 'location_channel.dart';

class SettingsService {
  final LocationChannel ch = LocationChannel();

  /// Abre los ajustes de fecha/hora del sistema (Android).
  Future<void> openTimeSettings() async {
    await ch.openTimeSettings();
  }
}
