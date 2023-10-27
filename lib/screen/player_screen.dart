import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:media_info/media_info.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/audio_model.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';

class PlayerScreen extends StatefulWidget {
  final AudioModel audio;

  const PlayerScreen({Key? key, required this.audio}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  var value = 0.0;
  bool isPlaying = true;
  Duration duration = const Duration();
  Duration position = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  double maxAudioLength = 0.0;
  final MediaInfo _mediaInfo = MediaInfo();

  // AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    maxAudioLength = await getAudioDuration(widget.audio.fullPath) / 1000.0;
    print("$maxAudioLength    AAAAAAAAAAAAAAAAAAAAAAAAAAA");

    await audioPlayer.play(DeviceFileSource(widget.audio.fullPath));
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    ///listen to audio duration
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = Provider.of<ThemeProvider>(context).getThemeMode();
    return Scaffold(
      body: Column(
        children: [
          getStatusBarWidget(context),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.maxFinite,
            height: 56,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
            ]),
            child: Row(
              children: [
                InkResponse(
                  onTap: () {
                    vibrateLight();
                    finish(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    widget.audio.fileName.replaceAll("Call recording", ""),
                    style: const TextStyle(fontSize: 18, fontFamily: "p_bold"),
                  ),
                )
              ],
            ),
          ),
          const Expanded(child: Icon(Icons.music_note_rounded,size: 200)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  formatTime(position),
                  style: const TextStyle(fontFamily: "p_thin"),
                ),
                Expanded(
                  child: Slider.adaptive(
                      min: 0.0,
                      activeColor: themeMode == ThemeMode.dark ? Colors.grey.shade300.withOpacity(.9)
                          : Colors.blueGrey.shade900,
                      inactiveColor: Colors.grey,
                      value: position.inSeconds.toDouble(),
                      max: maxAudioLength,
                      onChanged: (value1) async {
                        Duration newDuration = Duration(seconds: value1.toInt());
                        await audioPlayer.seek(newDuration);
                      }),
                ),
                Text(
                  formatTime(Duration(seconds: maxAudioLength.toInt()) - position),
                  style: const TextStyle(fontFamily: "p_thin"),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else if (!isPlaying) {
                        await audioPlayer.play(DeviceFileSource(widget.audio.fullPath));
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 36,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  Future<int> getAudioDuration(String path) async {
    return await MyApp.platform.invokeMethod("getAudioDuration", {"path": path});
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
