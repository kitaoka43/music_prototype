import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_prototype/ui/view/like_history_view/like_history_view.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/bottom_buttons_row.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/card_overlay.dart';
import 'package:music_prototype/ui/view/music_swipe_view/component/swipe_card.dart';
import 'package:swipable_stack/swipable_stack.dart';

// 消す
const _images = [
  'assets/image_5.jpg',
  'assets/image_3.jpg',
  'assets/image_4.jpg',
];
var selectedValue = "orange";
final lists = <String>["orange", "apple", "strawberry", "banana", "grape"];
// 消す

class MusicSwipeView extends StatefulWidget {
  const MusicSwipeView({super.key});

  @override
  _MusicSwipeViewState createState() => _MusicSwipeViewState();
}

class _MusicSwipeViewState extends State<MusicSwipeView> with SingleTickerProviderStateMixin {
  late final SwipableStackController _controller;
  late final AnimationController _animationController;

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    _animationController = AnimationController(duration: Duration(microseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
            Container(
              width: MediaQuery.of(context).size.width / 2.3,
              decoration: BoxDecoration(
                  color:Colors.white, //background color of dropdown button
                  borderRadius: BorderRadius.circular(15), //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[ //apply shadow on Dropdown button
                    BoxShadow(
                        color: Colors.black26, //shadow for button
                        blurRadius: 5) //blur radius of shadow
                  ]
              ),
              child: Padding(
                padding: EdgeInsets.only(left:30, right:30),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SwipableStack(
                        detectableSwipeDirections: const {
                          SwipeDirection.right,
                          SwipeDirection.left,
                        },
                        controller: _controller,
                        stackClipBehaviour: Clip.none,
                        onSwipeCompleted: (index, direction) {
                          if (kDebugMode) {
                            print('$index, $direction');
                          }
                        },
                        horizontalSwipeThreshold: 0.8,
                        verticalSwipeThreshold: 0.8,
                        builder: (context, properties) {
                          final itemIndex = properties.index % _images.length;

                          return Stack(
                            children: [
                              SwipeCard(
                                songTitle: "Bad guy",
                                artistName: "Billie eilish",
                                assetPath: _images[itemIndex],
                              ),
                              // more custom overlay possible than with overlayBuilder
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
