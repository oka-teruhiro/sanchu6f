import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShakeDetectorDemo(),
    );
  }
}

class ShakeDetectorDemo extends StatefulWidget {
  @override
  _ShakeDetectorDemoState createState() => _ShakeDetectorDemoState();
}

class _ShakeDetectorDemoState extends State<ShakeDetectorDemo> {
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
            title: Text("Shake Detected"),
            content: Text("You shook the device!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
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
        title: Text("Shake Detector Demo"),
      ),
      body: Center(
        child: Text("Shake your device to see the effect!"),
      ),
    );
  }
}