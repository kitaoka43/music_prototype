import 'package:music_kit/music_kit.dart';

class MusicKitLogic {
  static Future<void> initPlatformState(MusicKit musicKitPlugin) async {
    final status = await musicKitPlugin.authorizationStatus;

    final developerToken = await musicKitPlugin.requestDeveloperToken();
    final userToken = await musicKitPlugin.requestUserToken(developerToken);

    final countryCode = await musicKitPlugin.currentCountryCode;
    // final subs = await _musicSubsciption.canPlayCatalogContent;
  }
}