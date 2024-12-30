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
  String vpnStatus = 'Checking...';
  String internetStatus = 'Checking...';
  String packageInfo = 'Fetching...';
  String deviceId = 'Fetching...';

  @override
  void initState() {
    super.initState();

    // Start VPN and Internet status updates
    FlutterEssential.startVpnStatusUpdates();
    FlutterEssential.startInternetStatusUpdates();

    // Listen to VPN status updates
    FlutterEssential.vpnStatusStream.listen((status) {
      setState(() {
        vpnStatus = status ? 'VPN Connected' : 'VPN Disconnected';
      });
    });

    // Listen to Internet status updates
    FlutterEssential.internetStatusStream.listen((status) {
      setState(() {
        internetStatus =
            status ? 'Internet Connected' : 'Internet Disconnected';
      });
    });

    // Fetch package info
    FlutterEssential.getPackageInfo().then((info) {
      setState(() {
        if (info != null) {
          packageInfo =
              'App: ${info.appName}\nPackage: ${info.packageName}\nVersion: ${info.version}\nBuild: ${info.buildNumber}';
        } else {
          packageInfo = 'Failed to fetch package info.';
        }
      });
    });

    // Fetch device ID
    FlutterEssential.getDeviceId().then((id) {
      setState(() {
        if (id != null) {
          deviceId = 'Device ID: $id';
        } else {
          deviceId = 'Failed to fetch device ID.';
        }
      });
    });
  }

  @override
  void dispose() {
    // Stop VPN and Internet status updates
    FlutterEssential.stopVpnStatusUpdates();
    FlutterEssential.stopInternetStatusUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterEssential Plugin Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              spacing: 10,
              children: [
                Text('VPN Status: $vpnStatus'),
                Text('Internet Status: $internetStatus'),
                Text('Package Info:\n$packageInfo'),
                FilledButton(
                  onPressed: () async {
                    log('VPN Status: ${await FlutterEssential.isVpnConnected()}');
                  },
                  child: const Text('Check VPN Status'),
                ),
                Text(deviceId),
                FilledButton(
                  onPressed: () async {
                    log('Internet Status: ${await FlutterEssential.isInternetConnected()}');
                  },
                  child: const Text('Check Internet Status'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
