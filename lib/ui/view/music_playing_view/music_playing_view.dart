import 'dart:async';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/state/common/music_playing_state.dart';
import 'package:music_prototype/view_model/music_playing_view_model/music_playing_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicPlayingView extends ConsumerStatefulWidget {
  const MusicPlayingView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MusicPlayingViewState();
  }
}

class _MusicPlayingViewState extends ConsumerState<MusicPlayingView> with SingleTickerProviderStateMixin {
  void _listenController() => setState(() {});
  late final AnimationController _animationController;
  bool playingFlag = false;
  Timer? timerd;
  double allSecond = 0;
  double second = 0;

  // MusicKit関連の変数 --------------------------------------------------------------
  final _musicKitPlugin = MusicKit();
  MusicAuthorizationStatus _status = const MusicAuthorizationStatus.notDetermined();
  String _subsc = '';
  String? _developerToken = '';
  String _userToken = '';

  MusicSubscription _musicSubsciption = MusicSubscription();
  late StreamSubscription<MusicSubscription> _musicSubscriptionStreamSubscription;

  MusicPlayerState? _playerState;
  late StreamSubscription<MusicPlayerState> _playerStateStreamSubscription;

  MusicPlayerQueue? _playerQueue;
  late StreamSubscription<MusicPlayerQueue> _playerQueueStreamSubscription;

  // MusicKit関連の変数 --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(microseconds: 3000), vsync: this);

    //MusicKit関連
    initPlatformState();
    _musicKitPlugin.requestAuthorizationStatus();

    // サブスクリプションの監視
    _musicSubscriptionStreamSubscription = _musicKitPlugin.onSubscriptionUpdated.listen((event) {
      setState(() {
        _musicSubsciption = event;
      });
    });

    // 曲のPlay状態の監視
    _playerStateStreamSubscription = _musicKitPlugin.onMusicPlayerStateChanged.listen((event) {
      setState(() {
        _playerState = event;
      });
    });

    // 曲が変わったかどうかの監視
    _playerQueueStreamSubscription = _musicKitPlugin.onPlayerQueueChanged.listen((event) {
      setState(() {
        _playerQueue = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _musicSubscriptionStreamSubscription.cancel();
    _playerStateStreamSubscription.cancel();
    _playerQueueStreamSubscription.cancel();
    _animationController.dispose();
  }

  Future<void> initPlatformState() async {
    final status = await _musicKitPlugin.authorizationStatus;

    final developerToken = await _musicKitPlugin.requestDeveloperToken();
    final userToken = await _musicKitPlugin.requestUserToken(developerToken);

    final countryCode = await _musicKitPlugin.currentCountryCode;
    final subs = await _musicSubsciption.canPlayCatalogContent;

    if (!mounted) return;

    setState(() {
      _status = status;
      _developerToken = developerToken;
      _userToken = userToken;
      // _countryCode = countryCode;
      _subsc = subs.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    MusicPlayingViewModel vm = MusicPlayingViewModel();
    vm.setRef(ref, _musicKitPlugin);
    final musicList = ref.watch(musicPlayingCurrentMusicItemListProvider);
    final currentMusic = ref.watch(musicPlayingCurrentMusicItemProvider);
    final currentIndex = ref.watch(musicPlayingCurrentMusicItemIndexProvider);
    // 画面の高さ・幅取得
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Blur(
          blur: 2.5,
          borderRadius: BorderRadius.circular(14),
          child: Positioned.fill(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(currentMusic != null ? currentMusic.artworkUrl : ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120,),
              Container(
                height: 370,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                    image: NetworkImage(currentMusic != null ? currentMusic.artworkUrl : ""),
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [PopupMenuButton<String>(
              initialValue: null,
              onSelected: (String s) async {
                final Uri url = Uri.parse(currentMusic != null ? currentMusic.musicUrl : "");
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return ["Apple Musicで探す"].map((String s) {
                  return PopupMenuItem(
                    value: s,
                    child: Text(s),
                  );
                }).toList();
              },
            )],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0x33000000),
                        width: 1,
                      ),
                      color: const Color(0xbfafafaf),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: currentMusic != null
                                ? currentMusic.musicName.length <= 20
                                    ? FittedBox(
                                      child: Text(
                                        currentMusic.musicName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 32,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                    : Marquee(
                                        text: "${currentMusic.musicName}         ",
                                        style: const TextStyle(
                                          color: Color(0xff474646),
                                          fontSize: 34,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                        ),
                                        pauseAfterRound: const Duration(seconds: 2),
                                        startAfter: const Duration(seconds: 2),
                                      )
                                : Container(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FittedBox(
                            child: Text(
                              currentMusic != null ? currentMusic.artistName : "",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Slider(
                                  value: currentMusic == null || currentMusic.durationInSec == 0
                                      ? 0
                                      : ref.watch(playedSecondProvider) / currentMusic.durationInSec / 1000 <= 1
                                      ? ref.watch(playedSecondProvider) / currentMusic.durationInSec / 1000
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
                                          "-${(currentMusic!.durationInSec / 1000 - ref.watch(playedSecondProvider)) ~/ 60}:${((currentMusic.durationInSec / 1000 - ref.watch(playedSecondProvider)) % 60).toInt().toString().padLeft(2, '0')}"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 前の曲を再生する
                              Container(
                                height: 70,
                                width: 70,
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      playingFlag = true;
                                    });
                                    await vm.backMusicPlay();
                                    setState(() {
                                      playingFlag = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.skip_previous,
                                    size: 70,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              // 再生する
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      playingFlag = true;
                                    });
                                    timerd = Timer.periodic(const Duration(seconds: 1), (_) {
                                      // print("1秒毎に実行");
                                      _musicKitPlugin.playbackTime.then((value) {
                                        ref.watch(playedSecondProvider.notifier).state = value;
                                      });
                                    });
                                    if (_playerState == null || vm.isStop(_playerState!.playbackStatus)) {
                                      await vm.musicPlay();
                                    } else {
                                      await vm.musicStop();
                                    }
                                    setState(() {
                                      playingFlag = false;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topLeft,
                                          end: FractionalOffset.bottomRight,
                                          colors: [
                                            Colors.redAccent,
                                            Color(0xffe4a972),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        _playerState == null || vm.isStop(_playerState!.playbackStatus) ? Icons.play_arrow : Icons.pause,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // 次の曲を再生する
                              Container(
                                height: 70,
                                width: 70,
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      playingFlag = true;
                                    });
                                    await vm.nextMusicPlay();
                                    setState(() {
                                      playingFlag = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.skip_next,
                                    size: 70,
                                    color: Colors.grey.shade100,
                                  ),
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
        ),
        if (playingFlag == true)
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.4)),
            child: const Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }
}
