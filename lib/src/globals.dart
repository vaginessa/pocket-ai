import 'package:pocket_ai/src/modules/settings/models/app_settings.dart';

class Globals {
  static String? deviceId;

  // from Firestore when user has less than 5 sessions
  static String? freeOpenAiApiKey;

  // this will be overridden in splash screen init
  static AppSettings appSettings = AppSettings(
      maxTokensCount: 1500,
      openAiApiKey: null,
      generatedContentSignature: '- Pocket AI');
}
