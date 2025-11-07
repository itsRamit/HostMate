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
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
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
              width: 40,
              height: 40,
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
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: isRecording
                    ? AudioWaveforms(
                        enableGesture: false,
                        size: const Size(double.infinity, 40),
                        recorderController: recorder,
                        waveStyle: const WaveStyle(
                          waveColor: Colors.white,
                          extendWaveform: true,
                          showMiddleLine: false,
                        ),
                      )
                    : AudioFileWaveforms(
                        size: const Size(double.infinity, 40),
                        playerController: player,
                        waveformType: WaveformType.fitWidth,
                        playerWaveStyle: const PlayerWaveStyle(
                          fixedWaveColor: Colors.white54,
                          liveWaveColor: Colors.white,
                          waveCap: StrokeCap.round,
                          // extendWaveform: true,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            elapsedLabel,
            style: AppTextStyles.bodySRegular.copyWith(color: AppColors.text2),
          ),
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
