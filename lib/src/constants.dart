class AiBotConstants {
  static String introMessage =
      'Hi, I am Pocket AI bot. How can I help you today?';
  static String introMessageForContentGenerator =
      'Hello, I am Pocket AI bot. I can generate any type of content for you e.g. quote/poem/essay/story etc, which you can share with the world.';
}

class FirestoreCollectionsConst {
  static String faqs = 'faqs';
  static String userMessagesToBot = 'userMessagesToBot';
  static String messages = 'messages';
  static String openAiApiKeys = 'openAiApiKeys';
  static String userSessionsCount = 'userSessionsCount';
  static String contentGeneratorPrompts = 'contentGeneratorPrompts';
  static String prompts = 'prompts';
}

String androidPackageName = 'me.varunon9.pocket_ai';

class SharedPrefsKeys {
  static String maxTokensCount = 'maxTokensCount';
  static String openAiApiKey = 'openAiApiKey';
  static String generatedContentSignature = 'generatedContentSignature';
}
