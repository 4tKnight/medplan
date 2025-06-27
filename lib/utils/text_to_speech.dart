import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future<void> configureTts() async {}

void speakText(String text) async {
  await flutterTts.setSharedInstance(true);
  await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
    IosTextToSpeechAudioCategoryOptions.allowBluetooth,
    IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
    IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
  ], IosTextToSpeechAudioMode.defaultMode);

  await flutterTts.setLanguage('en-US');
  await flutterTts.setSpeechRate(1.0);
  await flutterTts.setVolume(1.0);
  await flutterTts.speak(text);
}

void stopSpeaking() async {
  await flutterTts.stop();
}
