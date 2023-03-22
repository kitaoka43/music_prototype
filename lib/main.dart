import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/repository/post_music_repository/post_music_repository.dart';
import 'package:music_prototype/ui/view/music_swipe_view/music_swipe_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PostMusicRepository.setDb();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Swipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicSwipeView(),
    );
  }
}
