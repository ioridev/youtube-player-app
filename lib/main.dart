import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const YouTubePlayerApp());
}

class YouTubePlayerApp extends StatelessWidget {
  const YouTubePlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'YouTube Player with Subtitles',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const YouTubePlayerScreen(),
      ),
    );
  }
}



final videoIdProvider = StateProvider<String>((ref) => 'dQw4w9WgXcQ');

final subtitleProvider = StateProvider<List<Map<String, String>>>((ref) => [
  {'en': 'Never gonna give you up', 'es': 'Nunca te abandonaré'},
  {'en': 'Never gonna let you down', 'es': 'Nunca te defraudaré'},
  {'en': 'Never gonna run around and desert you', 'es': 'Nunca correré y te abandonaré'},
  {'en': 'Never gonna make you cry', 'es': 'Nunca te haré llorar'},
  {'en': 'Never gonna say goodbye', 'es': 'Nunca diré adiós'},
  {'en': 'Never gonna tell a lie and hurt you', 'es': 'Nunca diré una mentira y te lastimaré'},
]);

final currentSubtitleIndexProvider = StateProvider<int>((ref) => 0);
final showEnglishProvider = StateProvider<bool>((ref) => true);

class YouTubePlayerScreen extends ConsumerWidget {
  const YouTubePlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoId = ref.watch(videoIdProvider);
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final subtitles = ref.watch(subtitleProvider);
                    final currentIndex = ref.watch(currentSubtitleIndexProvider);
                    final showEnglish = ref.watch(showEnglishProvider);
                    
                    if (currentIndex >= subtitles.length) return const SizedBox();
                    
                    return Text(
                      showEnglish 
                          ? subtitles[currentIndex]['en']!
                          : subtitles[currentIndex]['es']!,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final showEnglish = ref.watch(showEnglishProvider);
                        return ElevatedButton(
                          onPressed: () {
                            ref.read(showEnglishProvider.notifier).state = true;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: showEnglish ? Colors.blue : Colors.grey,
                          ),
                          child: const Text('English'),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    Consumer(
                      builder: (context, ref, child) {
                        final showEnglish = ref.watch(showEnglishProvider);
                        return ElevatedButton(
                          onPressed: () {
                            ref.read(showEnglishProvider.notifier).state = false;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !showEnglish ? Colors.blue : Colors.grey,
                          ),
                          child: const Text('Español'),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(currentSubtitleIndexProvider.notifier).state = 
                                (ref.read(currentSubtitleIndexProvider) - 1)
                                    .clamp(0, ref.read(subtitleProvider).length - 1);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(currentSubtitleIndexProvider.notifier).state = 
                                (ref.read(currentSubtitleIndexProvider) + 1)
                                    .clamp(0, ref.read(subtitleProvider).length - 1);
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


