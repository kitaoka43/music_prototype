import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/state/common/swipe_state.dart';

class SwipeCard extends ConsumerWidget {
  const SwipeCard({
    required this.musicItem,
    super.key,
  });

  final MusicItem musicItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 画面の高さ・幅取得
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);
    MusicItem? currentMusicItem = ref.watch(currentMusicItemProvider);
    double durationInSec = currentMusicItem == null ? 0 : currentMusicItem.durationInSec.toDouble() / 1000;
    return ClipRRect(
      child: Stack(
        children: [
          Blur(
            blur: 2.5,
            borderRadius: BorderRadius.circular(14),
            child: Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: NetworkImage(musicItem.artworkUrl),
                    // image: NetworkImage(musicItem.artworkUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 26,
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 21.1,
                ),
                Container(
                  height: height / 2.722,
                  width: width / 1.258,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    image: DecorationImage(
                      image: NetworkImage(musicItem.artworkUrl),
                      // image: NetworkImage(musicItem.artworkUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 26,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height / 4.22,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black12.withOpacity(0),
                    Colors.black12.withOpacity(.4),
                    Colors.black12.withOpacity(.82),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height / 3.836,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color(0x33000000),
                    width: 1,
                  ),
                  color: Color(0xb2d9d9d9),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: height / 42.2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 16.88,
                        child: musicItem.musicName.length <= 20
                            ? Text(
                                musicItem.musicName,
                                style: const TextStyle(
                                  color: Color(0xff474646),
                                  fontSize: 34,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Marquee(
                                text: "${musicItem.musicName}         ",
                                style: const TextStyle(
                                  color: Color(0xff474646),
                                  fontSize: 34,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                ),
                                pauseAfterRound: const Duration(seconds: 2),
                                startAfter: const Duration(seconds: 2),
                              ),
                      ),
                      SizedBox(
                        height: height / 168.8,
                      ),
                      FittedBox(
                        child: Text(
                          musicItem.artistName,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 56.267,
                      ),
                      Column(
                        children: [
                          Slider(
                            value: ref.watch(playedSecondProvider) == 0 && durationInSec == 0
                                ? 0
                                : ref.watch(playedSecondProvider) / durationInSec <= 1
                                    ? ref.watch(playedSecondProvider) / durationInSec
                                    : 1,
                            onChanged: (value) {
                              return;
                            },
                            activeColor: Colors.black26,
                            inactiveColor: Colors.grey.shade500,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 21.667),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${(ref.watch(playedSecondProvider) / 60).toInt()}:${(ref.watch(playedSecondProvider) % 60).toInt().toString().padLeft(2, '0')}"),
                                Text(
                                    "-${((durationInSec - ref.watch(playedSecondProvider)) / 60).toInt()}:${((durationInSec - ref.watch(playedSecondProvider)) % 60).toInt().toString().padLeft(2, '0')}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
