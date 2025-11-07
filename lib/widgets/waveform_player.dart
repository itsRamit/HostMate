import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformPlayer extends StatefulWidget {
  final String path;
  const WaveformPlayer({required this.path, super.key});

  @override
  State<WaveformPlayer> createState() => _WaveformPlayerState();
}

class _WaveformPlayerState extends State<WaveformPlayer> {
  late PlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();

    _controller.preparePlayer(
      path: widget.path,
      shouldExtractWaveform: true, 
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      size: Size(MediaQuery.of(context).size.width - 80, 64),
      playerController: _controller,
      waveformType: WaveformType.fitWidth,
      playerWaveStyle: const PlayerWaveStyle(
        fixedWaveColor: Colors.indigo,
        liveWaveColor: Colors.blueAccent,
        spacing: 6,
      ),
    );
  }
}
