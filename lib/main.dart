import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShakeDetectorDemo(),
    );
  }
}

class ShakeDetectorDemo extends StatefulWidget {
  const ShakeDetectorDemo({super.key});

  @override
  ShakeDetectorDemoState createState() => ShakeDetectorDemoState();
}

class ShakeDetectorDemoState extends State<ShakeDetectorDemo> {
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    // シェイク検出器を初期化し、シェイクが検出されたときのコールバックを設定します
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // シェイクが検出されたときの処理
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Shake Detected"),
            content: const Text("You shook the device!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // シェイク検出器を破棄します
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shake Detector Demo"),
      ),
      body: const Center(
        child: Text("Shake your device to see the effect!"),
      ),
    );
  }
}