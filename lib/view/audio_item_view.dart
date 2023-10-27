import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/providers/theme_provider.dart';
import 'package:crm/utils/hero_pusher_page_animation.dart';
import 'package:crm/utils/marquee_text.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/audio_model.dart';
import '../screen/player_screen.dart';
import '../utils/app_colors.dart';

class AudioItemView extends StatefulWidget {
  final AudioModel audio;
  final onClick;

  const AudioItemView({
    Key? key,
    required this.audio,
    this.onClick,
  }) : super(key: key);

  @override
  State<AudioItemView> createState() => _AudioItemViewState();
}

class _AudioItemViewState extends State<AudioItemView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
              BoxShadow(color: AppColors.BLACK.withOpacity(.2), blurRadius: 4, blurStyle: BlurStyle.outer)
            ]),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    widget.audio.sent ? AppColors.GREEN.withOpacity(.1) : Colors.deepOrange.withOpacity(.1),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.BLACK.withOpacity(.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.outer)
                ]),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 48,
                    height: 48,
                    // margin: const EdgeInsets.only(bottom: 14),
                    child: const Icon(Icons.audiotrack_rounded)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarqueeText(
                        child: Text(
                          widget.audio.fileName,
                          style: asTextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.audio.date.formatEprochToDate()),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(getFileSizeString(
                              bytes: File(widget.audio.fullPath).lengthSync(), decimals: 1)),
                        ],
                      ),
                      Text(
                        widget.audio.phone,
                        style: const TextStyle(
                          fontFamily: "p_med",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(top: 60, right: 16),
            child: Text(
              widget.audio.sent ? "Jo'natilgan" : "Yangi",
              style: TextStyle(
                fontFamily: "p_light",
                fontSize: 14,
                color: widget.audio.sent ? AppColors.GREEN : Colors.deepOrange,
              ),
            ),
          )
        ],
      ),
    );
  }
}
