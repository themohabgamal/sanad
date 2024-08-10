import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sanad/core/helpers/loading_sanad.dart';
import 'package:sanad/core/theme/my_colors.dart';

class QuranAudioDetailsScreen extends StatefulWidget {
  final String title;

  const QuranAudioDetailsScreen({super.key, required this.title});

  @override
  _QuranAudioDetailsScreenState createState() =>
      _QuranAudioDetailsScreenState();
}

class _QuranAudioDetailsScreenState extends State<QuranAudioDetailsScreen> {
  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _attachments = [];
  String? _currentDescription;
  String? _currentAudioUrl;
  bool _isPlaying = false; // Track the play/pause state

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final response = await _dio.get(
        'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/main/quran/ar/ar/1/25/json',
      );

      final List<dynamic> data = response.data['data'];

      // Find the data for the specified title
      final item = data.firstWhere(
        (element) => element['title'] == widget.title,
        orElse: () => {},
      );

      if (item.isNotEmpty) {
        final attachments = item['attachments'] as List<dynamic>;

        setState(() {
          _attachments = attachments.map<Map<String, dynamic>>((item) {
            return {
              'description': item['description'] ?? 'No description available',
              'url': item['url'],
            };
          }).toList();
          _currentDescription = item['description'] ??
              'No description available'; // Default value
        });
      } else {
        print("Title not found");
      }
    } catch (e) {
      print("Error fetching details: $e");
    }
  }

  void _togglePlay(String url) async {
    if (_isPlaying && _currentAudioUrl == url) {
      // If already playing the same URL, pause it
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      // If not playing or different URL, play the new URL
      try {
        await _audioPlayer.setUrl(url);
        setState(() {
          _currentAudioUrl = url;
          _isPlaying = true;
        });
        _audioPlayer.play();
      } catch (e) {
        print("Error playing audio: $e");
      }
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
          onPressed: () {
            Navigator.pop(context);
          },
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
          _attachments.isEmpty
              ? const LoadingSanad()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _attachments.length,
                    itemBuilder: (context, index) {
                      final attachment = _attachments[index];
                      final description = attachment['description'] ??
                          'No description available';
                      final url = attachment['url'];

                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          boxShadow: [MyColors.boxShadow],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              _isPlaying && _currentAudioUrl == url
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: MyColors.secondaryColor,
                            ),
                            onPressed: () {
                              if (url != null) {
                                _togglePlay(url);
                              }
                            },
                          ),
                          trailing: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: MyColors.secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                fontFamily: "Cairo"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
