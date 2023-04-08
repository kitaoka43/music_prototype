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
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 310,
                  width: 310,
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
              height: 200,
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
                height: 220,
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
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
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
                      const SizedBox(
                        height: 5,
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
                      SizedBox(height: 15,),
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
                            padding: const EdgeInsets.symmetric(horizontal: 18),
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
