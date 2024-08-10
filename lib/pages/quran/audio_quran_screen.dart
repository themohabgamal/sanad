import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sanad/core/helpers/loading_sanad.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'quran_audio_details_screen.dart'; // Import the new details screen

class AudioQuranScreen extends StatefulWidget {
  static const routeName = 'AudioQuranScreen';
  const AudioQuranScreen({super.key});

  @override
  _AudioQuranScreenState createState() => _AudioQuranScreenState();
}

class _AudioQuranScreenState extends State<AudioQuranScreen> {
  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _titles = [];
  String? _currentDescription;
  String? _currentAudioUrl;

  @override
  void initState() {
    super.initState();
    _fetchTitles();
  }

  Future<void> _fetchTitles() async {
    try {
      final response = await _dio.get(
        'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/quran/ar/ar/1/25/json',
      );

      final List<dynamic> data = response.data['data'];

      // Find the starting index
      final startIndex = data.indexWhere((item) =>
          item['title'] == "المصحف المرتل للقارئ شوقي عبد الصادق عبد الحميد");

      if (startIndex != -1) {
        // Get all titles starting from the specific title
        final filteredData = data.sublist(startIndex);

        setState(() {
          _titles = filteredData.map<Map<String, dynamic>>((item) {
            return {
              'title': item['title'],
              'description': item['description'],
              'attachments': item['attachments'],
              'api_url': item['api_url'], // Add api_url to be used later
            };
          }).toList();
        });
      } else {
        print("Title not found");
      }
    } catch (e) {
      print("Error fetching titles: $e");
    }
  }

  void _playAudio(String url, String description) async {
    try {
      await _audioPlayer.setUrl(url);
      setState(() {
        _currentDescription = description;
        _currentAudioUrl = url;
      });
      _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryHeavyColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryHeavyColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('القرآن الصوتي',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Cairo",
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _titles.isEmpty
              ? const LoadingSanad()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _titles.length,
                    itemBuilder: (context, index) {
                      final title = _titles[index];
                      final titleText = title['title'];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          boxShadow: [MyColors.boxShadow],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            titleText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: MyColors.secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Cairo"),
                          ),
                          onTap: () async {
                            final apiUrl = title['api_url'];
                            if (apiUrl != null) {
                              // Navigate to the details screen and pass the API URL
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuranAudioDetailsScreen(title: titleText),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
          if (_currentAudioUrl != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Currently Playing: $_currentDescription'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _audioPlayer.stop();
                },
                child: const Text('Stop'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
