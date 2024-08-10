import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sanad/core/helpers/loading_sanad.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/models/zekr.dart';
import 'package:sanad/widgets/zekr_list.dart';

class AzkarScreen extends StatefulWidget {
  final String azkarName;
  const AzkarScreen({super.key, required this.azkarName});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  List<Zekr>? _zekrList;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/json/azkar.json');

      // Parse the JSON data
      final jsonData = jsonDecode(jsonString);

      // Extract rows from JSON data
      final rows = jsonData['rows'] as List<dynamic>;

      List<dynamic> filteredRows;

      // Check if azkarName is "أذكار متنوعة"
      if (widget.azkarName == "أذكار متنوعة") {
        // Filter out the rows that match the three previous types
        final excludedTypes = [
          "أذكار الصباح",
          "أذكار المساء",
          "أذكار السفر"
        ]; // Add the actual types you want to exclude

        filteredRows = rows.where((row) {
          return !excludedTypes.contains(row[0]);
        }).toList();
      } else {
        // Filter rows based on azkarName
        filteredRows = rows.where((row) => row[0] == widget.azkarName).toList();
      }

      // Convert filtered rows to List of Zekr
      final List<Zekr> zekrList = filteredRows.map((row) {
        return Zekr(
          category: row[0].toString(),
          zekr: row[1].toString(),
          description: row[2].toString(),
          count: int.tryParse(row[3].toString()) ?? 0,
          reference: row[4].toString(),
          search: row[5].toString(),
        );
      }).toList();

      // Update the state with the loaded data
      setState(() {
        _zekrList = zekrList;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
      });
      print('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryHeavyColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: MyColors.primaryHeavyColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.azkarName,
          style: const TextStyle(
              fontFamily: "Cairo",
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: _zekrList == null
          ? const LoadingSanad()
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ZekrList(zekrList: _zekrList!),
    );
  }
}
