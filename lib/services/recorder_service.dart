import 'dart:convert';
import 'dart:io';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool initialized = false;

  Future<void> init() async {
    await _recorder.openRecorder();
    initialized = true;
  }

  Future<String?> startRecording() async {
    if (!initialized) await init();
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/audio_\${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: path);
    return path;
  }

  Future<void> stopRecording() async {
    if (!initialized) return;
    await _recorder.stopRecorder();
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
