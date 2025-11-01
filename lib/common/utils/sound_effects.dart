import "package:audioplayers/audioplayers.dart";

class SoundEffects {
  SoundEffects._();

  static final AudioPlayer _player = AudioPlayer();
  static bool _configured = false;

  static Future<void> playTap() async {
    try {
      if (!_configured) {
        await _player.setReleaseMode(ReleaseMode.stop);
        _configured = true;
      }
      await _player.stop();
      await _player.play(AssetSource("sounds/click.mp3"), volume: 0.4);
    } catch (_) {
      // Ignore playback issues silently.
    }
  }
}
