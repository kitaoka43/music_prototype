import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/music/genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/model/music_kit_api_arg/music_kit_api_arg.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:music_prototype/state/common/swipe_state.dart';
import 'package:music_prototype/state/like_music_state/like_music_state.dart';
import 'package:music_prototype/ui/view/like_history_view/like_history_view.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/card_overlay.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/swipe_card.dart';
import 'package:music_prototype/view_model/music_swipe_view_model/music_swipe_view_model.dart';
import 'package:swipable_stack/swipable_stack.dart';

class MusicSwipeView extends ConsumerStatefulWidget {
  const MusicSwipeView({super.key});

  @override
  _MusicSwipeViewState createState() => _MusicSwipeViewState();
}

class _MusicSwipeViewState extends ConsumerState<MusicSwipeView> with SingleTickerProviderStateMixin {
  late final SwipableStackController _swipeController;

  void _listenController() => setState(() {});
  late final AnimationController _animationController;
  Timer? timerd;
  bool swipingFlag = false;
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
    _swipeController = SwipableStackController();
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
    _swipeController
      ..removeListener(_listenController)
      ..dispose();
    _animationController.dispose();
  }

  Future<void> initPlatformState() async {
    final status = await _musicKitPlugin.authorizationStatus;
    final subs = _musicSubsciption.canPlayCatalogContent;

    final developerToken = await _musicKitPlugin.requestDeveloperToken();
    String userToken;
    try {
      userToken = await _musicKitPlugin.requestUserToken(developerToken);
    } catch (e) {
      userToken = "";
    }

    final countryCode = await _musicKitPlugin.currentCountryCode;
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
    // 画面の高さ・幅取得
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // viewModelのインスタンス化
    MusicSwipeViewModel vm = MusicSwipeViewModel();
    vm.setRef(ref);

    // ジャンルリスト
    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);
    MusicKitApiArg arg = MusicKitApiArg(developerToken: developerToken, userToken: userToken, genre: 0);
    final genreList = ref.watch(genreListProvider(arg));
    final selectedGenre = ref.watch(selectedGenreProvider);

    Future(() async {
      ref.watch(developerTokenProvider.notifier).state = _developerToken!;
      ref.watch(userTokenProvider.notifier).state = _userToken;
    });

    return Stack(
      children: [
        Scaffold(
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
                    // 音楽を止める
                    _musicKitPlugin.stop();
                    ref.refresh(likeMusicItemListProvider);
                    ref.refresh(likeGenreListProvider);
                    // リストを更新
                    vm.refreshMusic(selectedGenre);
                    _swipeController.currentIndex = 0;

                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const LikeHistoryView()));
                  },
                  child: SizedBox(
                      height: height / 16.88,
                      width: width / 7.8,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
          body: Center(
            child: genreList.when(
                error: (err, _) => Text(err.toString()), //エラー時
                loading: () => const CircularProgressIndicator(), //読み込み時
                data: (genreListData) {
                  String developerToken = ref.watch(developerTokenProvider);
                  String userToken = ref.watch(userTokenProvider);
                  String genre;
                  if (ref.watch(selectedGenreProvider) != null) {
                    genre = ref.watch(selectedGenreProvider)!.id;
                  } else {
                    genre = genreListData[0].id;
                  }
                  // 曲取得
                  MusicKitApiArg musicArg = MusicKitApiArg(developerToken: developerToken, userToken: userToken, genre: int.parse(genre));
                  final musicItemList = ref.watch(musicItemListProvider(musicArg));

                  return Column(
                    children: [
                      Container(
                        width: width / 1.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const <BoxShadow>[BoxShadow(color: Colors.black26, blurRadius: 5)]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: ref.watch(selectedGenreProvider)?.id,
                              items: genreListData
                                  .map((genre) => DropdownMenuItem(value: genre.id, child: Center(child: Text(genre.attributes["name"]!))))
                                  .toList(),
                              onChanged: (String? value) {
                                MusicKitApiArg newArg = arg.copyWith(genre: int.parse(value ?? "0"));
                                ref.refresh(musicItemListProvider(newArg));
                                setState(() {
                                  // ジャンルの選択処理
                                  for (Genre genre in genreListData) {
                                    if (genre.id == value) {
                                      ref.watch(beforeSelectedGenreProvider.notifier).state = ref.watch(selectedGenreProvider);
                                      ref.watch(selectedGenreProvider.notifier).state = genre;
                                    }
                                  }
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
                      musicItemList.when(
                          error: (err, _) => const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 250),
                                  child: Text("ネットワークエラーのため、アプリを再起動してください。"),
                                ),
                              ), //エラー時
                          loading: () => Center(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    height: height / 3.376,
                                  ),
                                  const CircularProgressIndicator(),
                                ],
                              )), //読み込み時
                          data: (musicItemListData) {
                            if (musicItemListData.isEmpty) {
                              return Container();
                            }

                            // ビルド後の処理
                            WidgetsBinding.instance.addPostFrameCallback((cb) async {
                              // 現在の曲を設定
                              ref.watch(currentMusicItemProvider.notifier).state = musicItemListData[_swipeController.currentIndex];
                              // 初期表示の場合、ジャンルの一番上を選択
                              if (ref.watch(selectedGenreProvider) == null || ref.watch(beforeSelectedGenreProvider) == null) {
                                ref.watch(selectedGenreProvider.notifier).state = genreListData[0];
                                ref.watch(beforeSelectedGenreProvider.notifier).state = genreListData[0];

                                //最初の曲を設定する
                                ref.watch(currentMusicItemProvider.notifier).state = musicItemListData[0];
                              } else if (ref.watch(beforeSelectedGenreProvider)!.id != ref.watch(selectedGenreProvider)!.id) {
                                // ジャンルが変更されていた場合、indexを初期化
                                _swipeController.currentIndex = 0;
                                ref.watch(beforeSelectedGenreProvider.notifier).state = ref.watch(selectedGenreProvider);
                                // ジャンルが再選択された場合、曲を流し直す
                                ref.watch(currentMusicItemProvider.notifier).state = musicItemListData[0];
                                if (_userToken.isNotEmpty) {
                                  await vm.musicPlay(_musicKitPlugin, musicItemListData[0]);
                                }
                              }
                            });

                            return SizedBox(
                              height: height / 1.298,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Stack(children: [
                                      const Center(child: Text("アイテムがありません")),
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SwipableStack(
                                          detectableSwipeDirections: const {
                                            SwipeDirection.right,
                                            SwipeDirection.left,
                                          },
                                          controller: _swipeController,
                                          itemCount: musicItemListData.length,
                                          stackClipBehaviour: Clip.none,
                                          onSwipeCompleted: (index, direction) async {
                                            setState(() {
                                              swipingFlag = true;
                                            });
                                            //スワイプ時の処理
                                            MusicItem musicItem = musicItemListData[index];
                                            MusicItem nextMusicItem = musicItemListData[index + 1];
                                            bool result = false;
                                            // like
                                            if (direction == SwipeDirection.right) {
                                              // like時の処理を行い、次の曲を流す
                                              result = await vm.swipeLike(musicItem, nextMusicItem);
                                              if (_userToken.isNotEmpty) {
                                                await vm.musicPlay(_musicKitPlugin, nextMusicItem);
                                              }
                                            } else {
                                              // bad時の処理を行い、次の曲を流す
                                              result = await vm.swipeBad(musicItem, nextMusicItem);
                                              if (_userToken.isNotEmpty) {
                                                await vm.musicPlay(_musicKitPlugin, nextMusicItem);
                                              }
                                            }
                                            setState(() {
                                              swipingFlag = false;
                                            });
                                          },
                                          horizontalSwipeThreshold: 0.8,
                                          verticalSwipeThreshold: 0.8,
                                          builder: (context, properties) {
                                            return Stack(
                                              children: [
                                                // スワイプカード
                                                SwipeCard(
                                                  musicItem: musicItemListData[properties.index],
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
                            );
                          }), //データ受け取り時
                    ],
                  );
                } //データ受け取り時
                ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 5.571,
                  height: height / 12.057,
                  child: FloatingActionButton(
                    onPressed: () async {
                      setState(() {
                        swipingFlag = true;
                      });
                      timerd = Timer.periodic(const Duration(seconds: 1), (_) {
                        // print("1秒毎に実行");
                        _musicKitPlugin.playbackTime.then((value) {
                          ref.watch(playedSecondProvider.notifier).state = value;
                        });
                      });
                      if (_playerState == null || vm.isStop(_playerState!.playbackStatus)) {
                        if (_userToken.isNotEmpty) {
                          await vm.musicPlay(_musicKitPlugin, ref.watch(currentMusicItemProvider));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("AppleMusicのメンバー以外は再生できません"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: const Text("OK"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        vm.musicStop(_musicKitPlugin);
                      }
                      setState(() {
                        swipingFlag = false;
                      });
                    },
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
        if (swipingFlag == true)
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
