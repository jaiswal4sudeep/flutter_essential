import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_essential/flutter_essential.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void checkInstallSource() async {
    final String source = await FlutterEssential.getAdvertisingId();
    log("App installed from: $source");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async => checkInstallSource(),
            child: Text('Test'),
          ),
        ),
      ),
    );
  }
}
