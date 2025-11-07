import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../provider/onboarding_provider.dart';
import '../theme.dart';
import '../widgets/recording_bar.dart';
import '../widgets/video_playback_card.dart';
import '../widgets/video_recording_preview.dart';
import '../widgets/action_icon_button.dart';
import '../widgets/stepper_bar.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'experience_screen.dart';

class OnboardingQuestionScreen extends ConsumerStatefulWidget {
  const OnboardingQuestionScreen({super.key});

  @override
  ConsumerState<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState
    extends ConsumerState<OnboardingQuestionScreen> {
  final _questionCtrl = TextEditingController();
  late final RecorderController _recorder;
  late final PlayerController _player;
  bool _isRecordingAudio = false;
  bool _isAudioPlaying = false;
  String? _audioPath;
  int _elapsedMs = 0;
  Timer? _ticker;
  CameraController? _cameraController;
  bool _isRecordingVideo = false;
  String? _videoPath;
  VideoPlayerController? _videoPlayer;

  @override
  void initState() {
    super.initState();
    _recorder = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 128000;
    _player = PlayerController();
    _questionCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    _player.dispose();
    _videoPlayer?.dispose();
    _cameraController?.dispose();
    _questionCtrl.dispose();
    super.dispose();
  }

  Future<String> _tempAudioPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> _startAudioRecording() async {
    if (_videoPath != null) await _deleteVideo();
    if (!await Permission.microphone.request().isGranted) return;
    final path = await _tempAudioPath();
    await _recorder.record(path: path);
    setState(() {
      _isRecordingAudio = true;
      _audioPath = path;
      _elapsedMs = 0;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedMs += 1000);
    });
  }

  Future<void> _stopAudioRecording() async {
    await _recorder.stop(false);
    _ticker?.cancel();
    if (_audioPath != null) {
      await _player.preparePlayer(
        path: _audioPath!,
        shouldExtractWaveform: true,
      );
    }
    if (!mounted) return;
    setState(() => _isRecordingAudio = false);
    ref.read(onboardingProvider.notifier).setAudioPath(_audioPath);
  }

  Future<void> _togglePlayAudio() async {
    if (_player.playerState == PlayerState.playing) {
      await _player.pausePlayer();
      setState(() => _isAudioPlaying = false);
    } else {
      await _player.seekTo(0);
      await _player.startPlayer();
      setState(() => _isAudioPlaying = true);
      _player.onCompletion.listen((_) {
        if (mounted) setState(() => _isAudioPlaying = false);
      });
    }
  }

  Future<void> _deleteAudio() async {
    _ticker?.cancel();
    if (_audioPath != null) {
      final f = File(_audioPath!);
      if (await f.exists()) await f.delete();
    }
    if (!mounted) return;
    setState(() {
      _audioPath = null;
      _isRecordingAudio = false;
      _isAudioPlaying = false;
      _elapsedMs = 0;
    });
    ref.read(onboardingProvider.notifier).setAudioPath(null);
  }

  Future<void> _startVideoRecording() async {
    if (_audioPath != null) await _deleteAudio();
    final camPerm = await Permission.camera.request();
    final micPerm = await Permission.microphone.request();
    if (!camPerm.isGranted || !micPerm.isGranted) return;
    final cams = await availableCameras();
    if (cams.isEmpty) return;
    final controller = CameraController(
      cams.first,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _cameraController = controller;
      _isRecordingVideo = true;
      _videoPath = null;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    await controller.startVideoRecording();
  }

  Future<void> _stopVideoRecording() async {
    final ctrl = _cameraController;
    if (ctrl == null ||
        !ctrl.value.isInitialized ||
        !ctrl.value.isRecordingVideo) {
      return;
    }
    final xfile = await ctrl.stopVideoRecording();
    final dir = await getTemporaryDirectory();
    final name = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final dest = '${dir.path}/$name';
    try {
      await File(xfile.path).rename(dest);
    } catch (_) {
      await File(xfile.path).copy(dest);
    }
    if (!mounted) return;
    setState(() {
      _isRecordingVideo = false;
      _videoPath = dest;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ctrl.dispose();
      } catch (_) {}
      _cameraController = null;
      await _initVideoPlayer(dest);
      ref.read(onboardingProvider.notifier).setVideoPath(dest);
    });
  }

  Future<void> _initVideoPlayer(String path) async {
    _videoPlayer?.dispose();
    final vp = VideoPlayerController.file(File(path));
    await vp.initialize();
    if (mounted) setState(() => _videoPlayer = vp);
  }

  Future<void> _deleteVideo() async {
    _videoPlayer?.dispose();
    if (_videoPath != null) {
      final f = File(_videoPath!);
      if (await f.exists()) await f.delete();
    }
    if (!mounted) return;
    setState(() {
      _videoPath = null;
      _videoPlayer = null;
      _isRecordingVideo = false;
    });
    ref.read(onboardingProvider.notifier).setVideoPath(null);
  }

  String _mmss(int ms) {
    final s = (ms ~/ 1000);
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasTyped = _questionCtrl.text.trim().isNotEmpty;
    final nextEnabled = hasTyped;
    return Scaffold(
      backgroundColor: AppColors.base2,
      appBar: AppBar(
        backgroundColor: AppColors.base2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const StepperBar(progress: 0.66,),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = MediaQuery.of(context).size.width;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(
                left: w * 0.04,
                right: w * 0.04,
                bottom: bottomInset + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('02', style: AppTextStyles.bodySRegular),
                      const SizedBox(height: 8),
                      const Text(
                        'Why do you want to host with us?',
                        style: AppTextStyles.h2Bold,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tell us about your intent and what motivates you to create experiences.',
                        style: AppTextStyles.bodyMRegular,
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _questionCtrl,
                        maxLines: 6,
                        maxLength: 600,
                        style: AppTextStyles.bodyMRegular,
                        decoration: const InputDecoration(
                          hintText: '/ Start typing here',
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (_isRecordingAudio || _audioPath != null)
                        RecordingBar(
                          isRecording: _isRecordingAudio,
                          isPlaying: _isAudioPlaying,
                          elapsedLabel: _isRecordingAudio
                              ? _mmss(_elapsedMs)
                              : _mmss(_player.maxDuration),
                          recorder: _recorder,
                          player: _player,
                          onDelete: _deleteAudio,
                          onPlayPause: _togglePlayAudio,
                        ),
                      if (_isRecordingVideo &&
                          _cameraController != null &&
                          _cameraController!.value.isInitialized)
                        VideoRecordingPreview(controller: _cameraController!),
                      if (!_isRecordingVideo &&
                          _videoPath != null &&
                          _videoPlayer != null)
                        VideoPlaybackCard(
                          player: _videoPlayer!,
                          onDelete: _deleteVideo,
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: h*0.08,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBlack2,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.border3,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          (!_isRecordingVideo &&
                                              _videoPath == null)
                                          ? () async {
                                              if (_isRecordingAudio) {
                                                await _stopAudioRecording();
                                              } else {
                                                await _startAudioRecording();
                                              }
                                            }
                                          : null,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: Icon(
                                          _isRecordingAudio
                                              ? Icons.stop_rounded
                                              : Icons.mic_none_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          (!_isRecordingAudio &&
                                              _audioPath == null)
                                          ? () async {
                                              if (_isRecordingVideo) {
                                                await _stopVideoRecording();
                                              } else {
                                                await _startVideoRecording();
                                              }
                                            }
                                          : null,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: Icon(
                                          _isRecordingVideo
                                              ? Icons.stop_rounded
                                              : Icons.videocam_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: w * 0.6,
                            child: GradientNextButton(
                              enabled: nextEnabled,
                              onPressed: nextEnabled
                                  ? () {
                                      debugPrint('Q: ${_questionCtrl.text}');
                                      debugPrint('Audio: $_audioPath');
                                      debugPrint('Video: $_videoPath');
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
