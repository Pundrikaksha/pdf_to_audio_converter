import 'dart:io';
import 'stt_api.dart';
import 'package:audioplayers/audioplayers.dart';

class Audio {
  Stt stt = Stt();
  AudioPlayer audioPlayer = AudioPlayer();
  Future<void> play(String text,
      {String lang = "en-US", String name = "en-US-Wavenet-A"}) async {
    File audioFile = await stt.getAudioFile(text, lang, name);
    await audioPlayer.play(audioFile.path);
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> resume() async {
    await audioPlayer.resume();
  }

  voice(String text, int val,
      {String lang = "en-US", String name = "en-US-Wavenet-A"}) async {
    switch (val) {
      case 1:
        lang = "en-IN";
        name = "en-IN-Wavenet-B";
        break;
      case 2:
        lang = "en-IN";
        name = "en-IN-Wavenet-A";
        break;
      case 3:
        lang = "en-IN";
        name = "en-IN-Standard-D";
        break;
      case 4:
        lang = "en-GB";
        name = "en-GB-Standard-A";
        break;
      case 5:
        lang = "en-IN";
        name = "en-IN-Wavenet-C";
        break;
    }
    File audioFile = await stt.getAudioFile(text, lang, name);
    await audioPlayer.play(audioFile.path);
  }
}
