import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/lugar_turistico.dart';

class DetalleViewModel extends ChangeNotifier {
  final LugarTuristico lugar;
  final AudioPlayer _reproductor = AudioPlayer();
  bool reproduciendo = false;

  DetalleViewModel(this.lugar);

  Future<void> alternarAudio() async {
    try {
      if (reproduciendo) {
        await _reproductor.pause();
        reproduciendo = false;
      } else {
        await _reproductor.play(AssetSource(lugar.audioAsset));
        reproduciendo = true;
      }
    } catch (e) {
      debugPrint('Error en reproducción de audio: $e');
      reproduciendo = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _reproductor.dispose();
    super.dispose();
  }
}
