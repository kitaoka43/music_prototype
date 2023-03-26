import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:music_prototype/ui/view/like_history_view/like_history_view.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/card_overlay.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/swipe_card.dart';
import 'package:swipable_stack/swipable_stack.dart';

// 消す
var selectedValue = "orange";
final lists = <String>["orange", "apple", "strawberry", "banana", "grape"];
// 消す

class MusicSwipeView extends ConsumerStatefulWidget {
  const MusicSwipeView({super.key});

  @override
  _MusicSwipeViewState createState() => _MusicSwipeViewState();
}

class _MusicSwipeViewState extends ConsumerState<MusicSwipeView> with SingleTickerProviderStateMixin {
  late final SwipableStackController _controller;
  late final AnimationController _animationController;
  List<MusicItem> musicItemList = List.empty();

  // MusicKit関連の変数
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
  // MusicKit関連の変数

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    _animationController = AnimationController(duration: Duration(microseconds: 500), vsync: this);

    //MusicKit関連
    initPlatformState();
    _musicKitPlugin.requestAuthorizationStatus();
    // _musicKitPlugin.authorizationStatus.then((value) => print(value));

    _musicSubscriptionStreamSubscription = _musicKitPlugin.onSubscriptionUpdated.listen((event) {
      setState(() {
        _musicSubsciption = event;
      });
    });

    _playerStateStreamSubscription = _musicKitPlugin.onMusicPlayerStateChanged.listen((event) {
      setState(() {
        _playerState = event;
      });
    });

    _playerQueueStreamSubscription = _musicKitPlugin.onPlayerQueueChanged.listen((event) {
      setState(() {
        _playerQueue = event;
      });
    });

    // musicItemList = MusicKitApiRepository
  }

  @override
  void dispose() {
    super.dispose();
    _musicSubscriptionStreamSubscription.cancel();
    _playerStateStreamSubscription.cancel();
    _playerQueueStreamSubscription.cancel();
    _controller
      ..removeListener(_listenController)
      ..dispose();
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Future(() async {
      // print(_developerToken);
      // Future.delayed(Duration(seconds: 10));
      ref.watch(developerTokenProvider.notifier).state = _developerToken!;
      ref.watch(userTokenProvider.notifier).state = _userToken;
      
      MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository(ref: ref);
      musicItemList = await musicKitApiRepository.getSongListData(18);
    });

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.blueAccent.shade700,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height / 105.5, horizontal: width / 48.75),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const LikeHistoryView()));
                },
                child: SizedBox(
                    height: height / 16.88,
                    width: width / 7.8,
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    )),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       initPlatformState();
            //     },
            //     child: Text("keke")),
            Container(
              width: MediaQuery.of(context).size.width / 2.3,
              decoration: BoxDecoration(
                  color: Colors.white, //background color of dropdown button
                  borderRadius: BorderRadius.circular(15), //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        color: Colors.black26, //shadow for button
                        blurRadius: 5) //blur radius of shadow
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items: lists.map((String list) => DropdownMenuItem(value: list, child: Text(list))).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: Colors.white,
                    elevation: 5,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 650,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Stack(children: [
                      Center(child: const Text("アイテムがありません")),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SwipableStack(
                          detectableSwipeDirections: const {
                            SwipeDirection.right,
                            SwipeDirection.left,
                          },
                          controller: _controller,
                          itemCount: musicItemList.length,
                          stackClipBehaviour: Clip.none,
                          onSwipeCompleted: (index, direction) {
                            //スワイプ時の処理をここに記述する
                          },
                          horizontalSwipeThreshold: 0.8,
                          verticalSwipeThreshold: 0.8,
                          builder: (context, properties) {
                            return Stack(
                              children: [
                                // スワイプカード
                                SwipeCard(
                                  songTitle: "Bad guy",
                                  artistName: "Billie eilish",
                                  assetPath: musicItemList[properties.index].artworkUrl,
                                ),
                                // オーバーレイ
                                if (properties.stackIndex == 0 && properties.direction != null)
                                  CardOverlay(
                                    swipeProgress: properties.swipeProgress,
                                    direction: properties.direction!,
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.only(bottom: 30),
          child: FloatingActionButton(
            onPressed: () {},
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
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Icon(
                    _animationController.isAnimating ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
