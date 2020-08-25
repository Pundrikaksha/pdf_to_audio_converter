import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Stt {
  var apiKey = 'AIzaSyDipvThF3x5JdRkOAQ4QSWhnFzZ6DCT1ks';

  Future<http.Response> voiceResponse(
      String text, String lang, String name) async {
    String url =
        'https://texttospeech.googleapis.com/v1beta1/text:synthesize?key=$apiKey';
    var body = jsonEncode({
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 1
      },
      "input": {"text": text},
      "voice": {"languageCode": lang, "name": name}
    });
    var response = http.post(url,
        headers: {"Content-type": "application/json"}, body: body);

    return (response);
  }

  Future<File> getAudioFile(String text, String lang, String name) async {
    var response = await voiceResponse(text, lang, name);
    var jsonData = jsonDecode(response.body);
    String audioBase64 = jsonData['audioContent'];
    var bytes = base64Decode(audioBase64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp3");
    await file.writeAsBytes(bytes);
    return file;
  }
}
