import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:tflite/tflite.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(CoughDetectorApp());
}

class CoughDetectorApp extends StatefulWidget {
  @override
  _CoughDetectorAppState createState() => _CoughDetectorAppState();
}

class _CoughDetectorAppState extends State<CoughDetectorApp> {
  final AudioRecorder _recorder = AudioRecorder(); // Correct class instantiation
  bool _isRecording = false;
  String? _recordedFilePath;
  String _predictionResult = "No prediction yet";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    // String res = await Tflite.loadModel(
    //   model: "assets/model.tflite",
    // );
    // print("Model loaded: $res");
    // String res = await tflite.loadModel(
    //   model:
    // )
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = "${tempDir.path}/cough_sound.m4a";

      await _recorder.start(const RecordConfig(), path: tempPath);

      setState(() {
        _isRecording = true;
        _recordedFilePath = tempPath;
      });

      // Stop recording automatically after 10 seconds
      Future.delayed(Duration(seconds: 10), () async {
        if (_isRecording) {
          await _stopRecording(); // Stop recording after 10 seconds
        }
      });
    } else {
      print("Permission denied to record audio.");
    }
  }

  Future<void> _playRecordedSound() async {
    if (_recordedFilePath != null) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(DeviceFileSource(_recordedFilePath!));
    } else {
      print("No recorded file to play.");
    }
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });

    if (_recordedFilePath != null) {
      _predictSound(_recordedFilePath!);
    }
  }

  Future<void> _predictSound(String filePath) async {
    // var result = await Tflite.runModelOnAudio(
    //   path: filePath,
    // );
    // setState(() {
    //   _predictionResult = result != null ? result.toString() : "No result";
    // });
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cough Disease Detection'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
            mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
            children: [
              Text(
                'Record your cough sound:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? null : _startRecording,
                child: Text('Start Recording'),
              ),
              ElevatedButton(
                onPressed: !_isRecording ? null : _stopRecording,
                child: Text('Stop Recording'),
              ),
              ElevatedButton(
                onPressed: !_isRecording && _recordedFilePath != null ? _playRecordedSound : null,
                child: Text('Play Recorded Sound'),
              ),
              SizedBox(height: 20),
              Text(
                'Prediction:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                _predictionResult,
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
