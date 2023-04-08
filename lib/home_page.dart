import 'package:chatgpt_dalle/openai_service.dart';
import 'package:chatgpt_dalle/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animate_do/animate_do.dart';

import 'feature_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  bool isLoading = false;
  String? GeneratedContent;
  String? GeneratedImgURl;
  String lastWords = "";
  int start = 200;
  int delay = 200;
  OpenAiService opai = OpenAiService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    print(result);
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> speak(String prompt) async {
    await flutterTts.speak(prompt);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.grey,
        title: BounceInDown(
          child: const Text(
            'Assistant',
            style: TextStyle(color: Colors.black, fontFamily: 'Cera Pro'),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ZoomIn(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: const BoxDecoration(
                                color: Pallete.assistantCircleColor,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Container(
                          height: 123,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/virtualAssistant.png"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  FadeInRight(
                    child: Visibility(
                      visible: GeneratedImgURl == null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 40),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30).copyWith(
                            topLeft: Radius.zero,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            GeneratedContent == null
                                ? "Good Morning, what task can I do for you?"
                                : GeneratedContent!,
                            style: TextStyle(
                                fontSize: GeneratedContent == null ? 24 : 18,
                                fontFamily: 'Cera Pro',
                                color: Pallete.mainFontColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (GeneratedImgURl != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(GeneratedImgURl!)),
                    ),
                  SlideInLeft(
                    child: Visibility(
                      visible:
                          GeneratedContent == null && GeneratedImgURl == null,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 22, top: 10),
                        child: const Text(
                          "Here are a few features",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera Pro',
                              color: Pallete.mainFontColor),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        GeneratedContent == null && GeneratedImgURl == null,
                    child: Column(
                      children: [
                        SlideInLeft(
                          delay: Duration(milliseconds: start),
                          child: const FeatureBox(
                            color: Pallete.firstSuggestionBoxColor,
                            headerText: "ChatGPT",
                            descriptionText:
                                "A smarter way to stay organized and informed with ChatGPT.",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + 2 * delay),
                          child: const FeatureBox(
                            color: Pallete.secondSuggestionBoxColor,
                            headerText: "Dall-E",
                            descriptionText:
                                "Get inspired and stay creative with your personal assistant powered by Dall-E.",
                          ),
                        ),
                        SlideInLeft(
                          delay: Duration(milliseconds: start + 3 * delay),
                          child: const FeatureBox(
                            color: Pallete.thirdSuggestionBoxColor,
                            headerText: "Smart Voice Assistant",
                            descriptionText:
                                "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 4 * delay),
        child: FloatingActionButton(
          tooltip: 'Listen',
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              startListening();

              final speech = await opai.isArtPrompt(lastWords);
              setState(() {
                isLoading = true;
              });
              if (speech.contains("https")) {
                setState(() {
                  GeneratedImgURl = speech;
                  GeneratedContent = null;
                  isLoading = false;
                });
              } else {
                setState(() {
                  GeneratedImgURl = null;
                  GeneratedContent = speech;
                  isLoading = false;
                });
                speak(speech);
              }
              stopListening();
            } else if (speechToText.isListening) {
              final speech = await opai.isArtPrompt(lastWords);
              setState(() {
                isLoading = true;
              });
              if (speech.contains("https")) {
                setState(() {
                  GeneratedImgURl = speech;
                  GeneratedContent = null;
                  isLoading = false;
                });
              } else {
                setState(() {
                  GeneratedImgURl = null;
                  GeneratedContent = speech;
                  isLoading = false;
                });
                speak(speech);
              }
              stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isNotListening ? Icons.mic : Icons.stop,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
