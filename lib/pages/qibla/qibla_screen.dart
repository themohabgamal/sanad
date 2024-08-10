import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/pages/qibla/qibla_compass.dart';

class QiblahScreen extends StatefulWidget {
  static const routeName = 'QiblahScreen';
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: MyColors.primaryHeavyColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryHeavyColor,
        title: const Text('القبلة',
            style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: MyColors.secondaryColor)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: FlutterQiblah.androidDeviceSensorSupport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            return const QiblaCompass();
          } else {
            return const Text('Error');
          }
        },
      ),
    ));
  }
}
