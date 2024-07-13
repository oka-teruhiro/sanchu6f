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
        title: const Text("Shake Detector Demo"),
      ),
      body: const Center(
        child: Text("Shake your device to see the effect!"),
      ),
    );
  }
}