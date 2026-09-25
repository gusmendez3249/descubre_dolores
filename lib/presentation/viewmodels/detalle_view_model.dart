import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/lugar_turistico.dart';

class DetalleViewModel extends ChangeNotifier {
  final LugarTuristico lugar;
  final AudioPlayer _reproductor = AudioPlayer();
  bool reproduciendo = false;
  double velocidad = 1.0;

  DetalleViewModel(this.lugar) {
    _reproductor.onPlayerComplete.listen((_) {
      reproduciendo = false;
      notifyListeners();
    });
  }

  Future<void> alternarAudio() async {
    try {
      if (reproduciendo) {
        await _reproductor.pause();
        reproduciendo = false;
      } else {
        await _reproductor.setPlaybackRate(velocidad);
        await _reproductor.play(AssetSource(lugar.audioAsset));
        reproduciendo = true;
      }
    } catch (e) {
      debugPrint('Error en reproducción de audio: $e');
      reproduciendo = false;
    }
    notifyListeners();
  }

  Future<void> cambiarVelocidad(double nuevaVelocidad) async {
    velocidad = nuevaVelocidad;
    try {
      await _reproductor.setPlaybackRate(velocidad);
    } catch (e) {
      debugPrint('Error al cambiar velocidad: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _reproductor.dispose();
    super.dispose();
  }
}

