import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../theme.dart';

class RecordingBar extends StatelessWidget {
  final bool isRecording;
  final bool isPlaying;
  final String elapsedLabel;
  final RecorderController recorder;
  final PlayerController player;
  final VoidCallback onPlayPause;
  final VoidCallback onDelete;

  const RecordingBar({
    super.key,
    required this.isRecording,
    required this.isPlaying,
    required this.elapsedLabel,
    required this.recorder,
    required this.player,
    required this.onPlayPause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border3, width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isRecording ? null : onPlayPause,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRecording
                    ? Icons.mic
                    : (isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 40,
              child: isRecording
                  ? AudioWaveforms(
                      enableGesture: false,
                      size: Size(w - 180, 40),
                      recorderController: recorder,
                    )
                  : AudioFileWaveforms(
                      size: Size(w - 180, 40),
                      playerController: player,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: const PlayerWaveStyle(
                        fixedWaveColor: Colors.white70,
                        liveWaveColor: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Text(elapsedLabel,
              style: AppTextStyles.bodySRegular
                  .copyWith(color: AppColors.text2)),
          if (!isRecording)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
