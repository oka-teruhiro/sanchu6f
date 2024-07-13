import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

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
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  static const double shakeThreshold = 15.0;
  int _shakeCount = 0;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription =
        //accelerometerEvents.listen((AccelerometerEvent event) {
    accelerometerEventStream().listen((AccelerometerEvent event) {
          final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

          if (acceleration > shakeThreshold) {
            final DateTime now = DateTime.now();
            if (now.difference(_lastShakeTime).inMilliseconds > 1000) {
              _lastShakeTime = now;
              _shakeCount++;
              if (_shakeCount >= 2) {
                _shakeCount = 0;
                _onShakeDetected();
              }
            }
          }
        });
  }

  void _onShakeDetected() {
    showDialog(
      context: context,
      builder: (context) => OrientationDetector(),
      /*builder: (context) => AlertDialog(
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
      ),*/
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("おみくじ"),
      ),
      body: const Center(
        child: Text("スマホを１秒以上振ってから、画面を下向きにしてください"),
      ),
    );
  }
}

class OrientationDetector extends StatefulWidget {
  @override
  _OrientationDetectorState createState() => _OrientationDetectorState();
}

class _OrientationDetectorState extends State<OrientationDetector> {
  bool isFaceDown = false; // 画面は上向きだ
  bool wasFaceDownForOneSecond = false; // 画面下向き一秒以上だ」をリセットする
  DateTime? faceDownStartTime; // 下向き開始時刻は？まだ設定されていない

  @override
  void initState() {
    super.initState(); // 初期設定
    accelerometerEvents.listen((AccelerometerEvent event) { // 重力センサーを監視せよ
      setState(() {
        if (event.z < -9) { // 画面表面方向に引く力（重力）が働いたら・・・
          if (!isFaceDown) { // 画面が上向きだったら
            isFaceDown = true; // 画面は下向きだよ」に変更する
            faceDownStartTime = DateTime.now(); // 画面が下向きになった時刻を記憶する
          } else if (faceDownStartTime != null && // もし画面下向き時刻が設定されていて、さらに、
              DateTime.now().difference(faceDownStartTime!).inSeconds >= 1) { // 画面下向き時間が１秒以上なら
            wasFaceDownForOneSecond = true; // 画面下向き一秒以上だ」を設定する
          }
        } else { // 画面表方向に引く力が（重力）がなくなったら
          if (isFaceDown) { // もしすでに画面が下向きで、
            if (wasFaceDownForOneSecond) { // さらに、画面下向き一秒以上なら、
              // 1秒以上下向きから上向きになったことを検出
              print('Device was face down for over 1 second and is now face up');
              wasFaceDownForOneSecond = false; // 画面下向き一秒以上をリセットする
            }
            isFaceDown = false; // 画面は上向きだ」に設定
            faceDownStartTime = null; // 画面下向き時刻をリセットする
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('画面の向きを検出'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              isFaceDown ? '下向きです' : '上向きです',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>const ShakeDetectorDemo(),
                      ));
                },
                child: const Text(
                  'もう一度試す',
                  style: TextStyle(
                    fontSize: 20,
                  ),

                )),
          ],
        ),
      ),
    );
  }
}
