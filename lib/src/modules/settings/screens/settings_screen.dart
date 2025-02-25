import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pocket_ai/src/constants.dart';
import 'package:pocket_ai/src/globals.dart';
import 'package:pocket_ai/src/modules/faqs/screens/faqs_screen.dart';
import 'package:pocket_ai/src/modules/settings/models/app_settings.dart';
import 'package:pocket_ai/src/utils/analytics.dart';
import 'package:pocket_ai/src/utils/common.dart';
import 'package:pocket_ai/src/widgets/custom_colors.dart';
import 'package:pocket_ai/src/widgets/custom_elevated_button.dart';
import 'package:pocket_ai/src/widgets/custom_text.dart';
import 'package:pocket_ai/src/widgets/custom_text_form_field.dart';
import 'package:pocket_ai/src/widgets/heading.dart';
import 'package:pocket_ai/src/widgets/link_text.dart';
import 'package:pocket_ai/src/widgets/scroll_view_with_height.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  TextEditingController apiKeyController = TextEditingController();
  TextEditingController maxTokensController = TextEditingController();
  TextEditingController generatedContentSignatureController =
      TextEditingController();
  String appVersion = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    // check for free api key
    if (Globals.freeOpenAiApiKey != Globals.appSettings.openAiApiKey) {
      apiKeyController.text = Globals.appSettings.openAiApiKey ?? '';
    }
    maxTokensController.text = Globals.appSettings.maxTokensCount.toString();
    generatedContentSignatureController.text =
        Globals.appSettings.generatedContentSignature ?? '';
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
    logEvent(EventNames.settingsScreenViewed, {});
  }

  void onUpdateSettingsOress() async {
    String openAiApiKey = apiKeyController.text;
    if (openAiApiKey.isEmpty) {
      showSnackBar(context, message: 'API key is mandatory');
      return;
    }
    logEvent(EventNames.updateSettingsClicked, {});
    int maxTokensCount = int.parse(maxTokensController.text);
    String generatedContentSignature = generatedContentSignatureController.text;
    AppSettings updatedAppSettings = AppSettings(
        maxTokensCount: maxTokensCount,
        openAiApiKey: openAiApiKey,
        generatedContentSignature: generatedContentSignature);
    Globals.appSettings = updatedAppSettings;

    saveAppSettingsToSharedPres(updatedAppSettings);
    showSnackBar(context, message: 'Changes saved successfully!');
  }

  void onKnowledgeCenterPress() {
    logEvent(EventNames.faqsClicked, {});
    navigateToScreen(context, FaqsScreen.routeName);
  }

  void onRateThisAppPress() async {
    logEvent(EventNames.rateAppClicked, {});
    if (Platform.isAndroid || Platform.isIOS) {
      // todo support for ios
      final appId = Platform.isAndroid ? androidPackageName : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      bool canLaunchIntent = await canLaunchUrl(url);
      if (canLaunchIntent) {
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        launchUrlString(
            'https://play.google.com/store/apps/details?id=$androidPackageName');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Heading(
          'Settings',
          type: HeadingType.h4,
        ),
        backgroundColor: CustomColors.darkBackground,
        actions: <Widget>[
          IconButton(
              tooltip: 'Back',
              onPressed: (() {
                goBack(context);
              }),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: ScrollViewWithHeight(
          child: Container(
              padding: const EdgeInsets.all(16),
              color: CustomColors.darkBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    'OpenAI API Key',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const CustomText(
                        'This key will be saved to your device so that only you can use it. You can get it for free from https://beta.openai.com/account/api-keys',
                        style: TextStyle(
                            color: CustomColors.lightText, fontSize: 11),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    child: CustomTextFormField(
                        controller: apiKeyController,
                        onChanged: (value) => {},
                        hintText: 'sk-T7q1L8p5G****'),
                  ),
                  const CustomText(
                    'Maximum length of AI bot response',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const CustomText(
                        'The maximum number of tokens to generate. The GPT family of models process text using tokens, which are common sequences of characters found in text. Visit https://platform.openai.com/tokenizer',
                        style: TextStyle(
                            color: CustomColors.lightText, fontSize: 11),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    child: CustomTextFormField(
                        textInputType: TextInputType.number,
                        controller: maxTokensController,
                        onChanged: (value) => {},
                        hintText: '1500'),
                  ),
                  const CustomText(
                    'Signature for generated content',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const CustomText(
                        'This signature will be used in image created by generated content',
                        style: TextStyle(
                            color: CustomColors.lightText, fontSize: 11),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    child: CustomTextFormField(
                        controller: generatedContentSignatureController,
                        onChanged: (value) => {},
                        hintText: '- Pocket AI'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 36, bottom: 36),
                    child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: CustomElevatedButton(
                            onPressed: onUpdateSettingsOress, text: 'Update')),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: LinkText(
                          text: 'Knowledge Center & FAQs',
                          onPress: onKnowledgeCenterPress)),
                  Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: LinkText(
                          text: 'Rate this app', onPress: onRateThisAppPress)),
                  Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Center(
                          child: CustomText(
                        'Build v$appVersion - $buildNumber',
                        size: CustomTextSize.small,
                        style: const TextStyle(color: CustomColors.lightText),
                      ))),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Center(
                          child: CustomText(
                        '🇮🇳  Made in India',
                        size: CustomTextSize.small,
                        style: TextStyle(color: CustomColors.lightText),
                      )))
                ],
              ))),
    ));
  }
}
