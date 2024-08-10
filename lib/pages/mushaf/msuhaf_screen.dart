import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sanad/core/theme/my_colors.dart';

class MushafScreen extends StatefulWidget {
  static const String routeName = "MushafScreen";
  const MushafScreen({super.key});

  @override
  _MushafScreenState createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  final int totalPages = quran.totalPagesCount;
  late List<Map<String, dynamic>> pageData;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isFocused = false; // New state for focus mode

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    pageData = List.generate(totalPages, (index) {
      final pageNumber = index + 1;
      final pageSurahs = quran.getPageData(pageNumber);

      String surahName = "";
      String pageText = "";

      for (var surahData in pageSurahs) {
        final surahNumber = surahData['surah'] as int?;
        final startVerse = surahData['start'] as int?;
        final endVerse = surahData['end'] as int?;

        if (surahNumber != null && startVerse != null && endVerse != null) {
          // Get Surah name
          surahName = quran.getSurahNameArabic(surahNumber);

          // Get verses for the page
          final verses = quran.getVersesTextByPage(pageNumber);

          int verseCounter = startVerse;
          pageText = verses.map((verse) {
            final verseWithCounter =
                '$verse \uFD3F ${convertToArabicNumerals(verseCounter)} \uFD3E';
            verseCounter++;
            return verseWithCounter;
          }).join(' '); // Join verses with space
        }
      }

      return {
        'pageNumber': pageNumber,
        'totalPages': totalPages,
        'verses': pageText,
        'surahName': surahName,
      };
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String convertToArabicNumerals(int number) {
    const arabicNumerals = '٠١٢٣٤٥٦٧٨٩';
    return number
        .toString()
        .split('')
        .map((char) => arabicNumerals[int.parse(char)])
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    final currentPageData = pageData[_currentPage];
    final currentSurahName = currentPageData['surahName'] as String;
    final currentPageNumber = currentPageData['pageNumber'] as int;
    final totalPageNumber = currentPageData['totalPages'] as int;

    return Scaffold(
      backgroundColor: MyColors.primaryHeavyColor,
      appBar: _isFocused
          ? null
          : AppBar(
              backgroundColor: MyColors.primaryHeavyColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                currentSurahName.isNotEmpty ? currentSurahName : 'المصحف',
                style: const TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: MyColors.secondaryColor),
              ),
            ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isFocused = !_isFocused;
          });
        },
        child: PageView.builder(
          controller: _pageController,
          reverse: true,
          itemCount: totalPages,
          itemBuilder: (context, index) {
            final data = pageData[index];
            final pageText = data['verses'] as String;
            final pageNumber = data['pageNumber'] as int;
            final totalPages = data['totalPages'] as int;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              color: MyColors.primaryHeavyColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display Surah Name
                  if (currentSurahName.isNotEmpty)
                    Expanded(
                      child: SafeArea(
                        child: Text(
                          pageText,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: "Hafs",
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // Page Indicator
                  if (!_isFocused)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${convertToArabicNumerals(pageNumber)} / ${convertToArabicNumerals(totalPages)}',
                        style: const TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.secondaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
