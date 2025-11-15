import 'package:audioplayers/audioplayers.dart';

class MusicService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const String defaultMusicUrl = 'https://audio.jukehost.co.uk/WQF2nafozymUdCIyomH2I1R1v41NO4hk';

  Future<void> initialize() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> play(String? customUrl, double volume) async {
    try {
      final url = (customUrl != null && customUrl.isNotEmpty) ? customUrl : defaultMusicUrl;
      await _audioPlayer.setVolume(volume / 100);
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume / 100);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;
}
