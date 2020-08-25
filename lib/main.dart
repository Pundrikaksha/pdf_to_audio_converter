import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:text_speech/audio.dart';
import 'Text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = s;
  PDFDoc pdfDoc;
  bool spinner = false;
  int val = 0;
  FlutterTts flutterTts = FlutterTts();
  Audio audio = Audio();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              if (val > 5) val = 0;
              val++;
            });
            setState(() {
              spinner = true;
            });
            await audio.voice(text, val);
            setState(() {
              spinner = false;
            });
          },
          child: Icon(Icons.record_voice_over),
        ),
        appBar: AppBar(
          actions: <Widget>[
            Expanded(
              child: FlatButton.icon(
                onPressed: () {
                  filePick();
                },
                label: Text("pick pdf"),
                icon: Icon(Icons.picture_as_pdf),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });

                  await audio.play(text,
                      lang: "en-IN", name: "en-IN-Wavenet-A");
                  setState(() {
                    spinner = false;
                  });

                  isPlaying = true;
                },
                label: Text("play"),
                icon: Icon(Icons.play_circle_filled),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                icon: Icon(
                  isPlaying ? Icons.play_arrow : Icons.pause,
                ),
                onPressed: () {
                  isPlaying ? audio.pause() : audio.resume();
                  setState(() {
                    isPlaying = isPlaying ? false : true;
                  });
                },
                label: isPlaying ? Text("resume") : Text("pause"),
              ),
            ),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: spinner,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5, bottom: 10),
            child: ListView(
              children: [
                Text(
                  text,
                  style:
                      TextStyle(color: Colors.blueGrey.shade700, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future filePick() async {
    setState(() {
      spinner = true;
    });
    String filepath = await FilePicker.getFilePath(type: FileType.any);
    pdfDoc = await PDFDoc.fromPath(filepath);
    String data = await pdfDoc.text;

    setState(() {
      text = data;
    });

    setState(() {
      spinner = false;
    });
  }

  voiceModule() {}
}
