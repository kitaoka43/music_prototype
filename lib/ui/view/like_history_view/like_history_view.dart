import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:music_prototype/state/common/music_playing_state.dart';
import 'package:music_prototype/state/common/swipe_state.dart';
import 'package:music_prototype/state/like_music_state/like_music_state.dart';
import 'package:music_prototype/ui/view/music_playing_view/music_playing_view.dart';

class LikeHistoryView extends ConsumerStatefulWidget {
  const LikeHistoryView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LikeHistoryViewState();
  }
}

class _LikeHistoryViewState extends ConsumerState<LikeHistoryView> with SingleTickerProviderStateMixin {
  void _listenController() => setState(() {});
  late final AnimationController _animationController;
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
    final genreList = ref.watch(likeGenreListProvider);
    final selectedLikeGenre = ref.watch(selectedLikeGenreProvider);
    final beforeSelectedLikeGenre = ref.watch(beforeSelectedLikeGenreProvider);
    AsyncValue<List<LikeMusic>> musicItemList = ref.watch(likeMusicItemListProvider);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              genreList.when(
                error: (err, _) => Text(err.toString()), //エラー時
                loading: () => const CircularProgressIndicator(), //読み込み時
                data: (genreListData) {
                  //ビルド完了後の処理
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    // 初期表示の場合
                    if (selectedLikeGenre == null || beforeSelectedLikeGenre == null) {
                      ref.watch(selectedLikeGenreProvider.notifier).state = genreListData[0];
                      ref.watch(beforeSelectedLikeGenreProvider.notifier).state = genreListData[0];
                      ref.refresh(likeMusicItemListProvider);
                    }
                  });
                  return Container(
                    width: MediaQuery.of(context).size.width / 1.5,
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
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLikeGenre?.id,
                          items: genreListData
                              .map((genre) => DropdownMenuItem(value: genre.id, child: Center(child: Text(genre.attributes["name"]!))))
                              .toList(),
                          onChanged: (String? value) {
                            // ジャンルの選択処理
                            for (Genre genre in genreListData) {
                              if (genre.id == value) {
                                ref.watch(beforeSelectedLikeGenreProvider.notifier).state = selectedLikeGenre;
                                ref.watch(selectedLikeGenreProvider.notifier).state = genre;
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: Colors.white,
                          elevation: 5,
                          isExpanded: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              musicItemList.when(
                  error: (err, _) => Text(err.toString()), //エラー時
                  loading: () => const CircularProgressIndicator(), //読み込み時
                  data: (likeMusicListData) {
                    return likeMusicListData.isEmpty
                        ? Container()
                        : SingleChildScrollView(
                            child: SizedBox(
                              height: 680,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // 情報を設定して、画面遷移
                                      ref.watch(musicPlayingCurrentMusicItemListProvider.notifier).state = likeMusicListData;
                                      ref.watch(musicPlayingCurrentMusicItemProvider.notifier).state = likeMusicListData[index];
                                      ref.watch(musicPlayingCurrentMusicItemIndexProvider.notifier).state = index;
                                      Navigator.push(context, MaterialPageRoute(builder: (builder) => const MusicPlayingView()));
                                    },
                                    child: SizedBox(
                                      height: 85,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(14),
                                                      image: DecorationImage(
                                                        image: NetworkImage(likeMusicListData[index].artworkUrl),
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
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(likeMusicListData[index].musicName),
                                                    Text(likeMusicListData[index].artistName),
                                                  ],
                                                ),
                                                const Icon(Icons.more_vert)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          const Divider(
                                            height: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: likeMusicListData.length,
                              ),
                            ),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
