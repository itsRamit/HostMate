import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:host_mate/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

class VideoPlaybackCard extends StatefulWidget {
  final VideoPlayerController player;
  final VoidCallback onDelete;
  const VideoPlaybackCard({required this.player, required this.onDelete});

  @override
  State<VideoPlaybackCard> createState() => VideoPlaybackCardState();
}

class VideoPlaybackCardState extends State<VideoPlaybackCard> {
  bool expanded = false;
  Uint8List? thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final t = await vt.VideoThumbnail.thumbnailData(
      video: widget.player.dataSource,
      imageFormat: vt.ImageFormat.JPEG,
      timeMs: 2000,
      maxWidth: 256,
      quality: 85,
    );
    if (mounted) setState(() => thumb = t);
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final duration = widget.player.value.duration;

    if (!expanded) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceBlack2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border3),
        ),
        child: ListTile(
          onTap: () => setState(() => expanded = true),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 52,
              height: 52,
              child: thumb != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(thumb!, fit: BoxFit.cover),
                        const Center(
                          child: Icon(Icons.play_arrow, color: Colors.white70, size: 22),
                        ),
                      ],
                    )
                  : Container(
                      color: Colors.black26,
                      child: const Icon(Icons.play_arrow, color: Colors.white38, size: 26),
                    ),
            ),
          ),
          title: Row(
            children: [
              const Text('Video Recorded', style: AppTextStyles.bodyMRegular),
              const SizedBox(width: 6),
              Text('• ${_fmt(duration)}',
                  style: AppTextStyles.bodySRegular.copyWith(color: AppColors.text3)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: widget.onDelete,
          ),
        ),
      );
    }

    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: widget.player.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(widget.player),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    if (widget.player.value.isPlaying) {
                      await widget.player.pause();
                    } else {
                      await widget.player.setLooping(true);
                      await widget.player.play();
                    }
                    setState(() {});
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: widget.player.value.isPlaying ? 0.0 : 0.9,
                    child: const Icon(Icons.play_circle_fill, size: 56, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => setState(() => expanded = false),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                const Icon(Icons.videocam, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Video Recorded • ${_fmt(duration)}',
                    style: AppTextStyles.bodyMRegular.copyWith(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white70),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
