import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:host_mate/theme.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool active;
  const ActionIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.active,
  });
  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: active ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceBlack1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border3, width: 1),
            ),
            child: Icon(icon,
                color: active ? AppColors.text1 : AppColors.text3),
          ),
        ),
      );
}

class _RecordingBar extends StatelessWidget {
  final bool isRecording;
  final bool isPlaying;
  final String elapsedLabel;
  final RecorderController recorder;
  final PlayerController player;
  final VoidCallback onPlayPause;
  final VoidCallback onDelete;

  const _RecordingBar({
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
                      waveStyle: WaveStyle(
                        waveThickness: 3,
                        showMiddleLine: false,
                        extendWaveform: true,
                        gradient: const LinearGradient(
                          colors: [Colors.white70, Colors.white],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                      ),
                    )
                  : AudioFileWaveforms(
                      size: Size(w - 180, 40),
                      playerController: player,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: const PlayerWaveStyle(
                        fixedWaveColor: Colors.white70,
                        liveWaveColor: Colors.white,
                        waveCap: StrokeCap.round,
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
