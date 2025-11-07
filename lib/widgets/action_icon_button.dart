import 'package:flutter/material.dart';
import '../theme.dart';

class MediaActionBar extends StatelessWidget {
  final bool isRecordingAudio;
  final bool isRecordingVideo;
  final bool hasAudio;
  final bool hasVideo;
  final VoidCallback onAudioTap;
  final VoidCallback onVideoTap;

  const MediaActionBar({
    super.key,
    required this.isRecordingAudio,
    required this.isRecordingVideo,
    required this.hasAudio,
    required this.hasVideo,
    required this.onAudioTap,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border3, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              onTap: (!isRecordingVideo && !hasVideo) ? onAudioTap : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Icon(
                  isRecordingAudio ? Icons.stop_rounded : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withOpacity(0.2),
          ),
          Expanded(
            child: InkWell(
              onTap: (!isRecordingAudio && !hasAudio) ? onVideoTap : null,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Icon(
                  isRecordingVideo ? Icons.stop_rounded : Icons.videocam_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
