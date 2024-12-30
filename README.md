# Flutter Essential Plugin

A customizable Flutter plugin for common app requirements such as VPN detection, internet connectivity checks, package information retrieval, and device identification.

## Features

This plugin offers the following features:

1. **VPN Status Checker**: Detects whether the device is connected to a VPN.
2. **Internet Connectivity Checker**: Verifies whether the device has an active internet connection (via Wi-Fi or Mobile Data).
3. **Package Information**: Retrieves app metadata such as app name, package name, version, and build number.
4. **Device ID**: Fetches the unique Android ID for the device.

## Installation

Add this plugin to your `pubspec.yaml` file:

```yaml
flutter_essential:
  git:
    url: https://github.com/Apex-Eagle-Solution-LLC/flutter_essential.git
```

Run:

```sh
flutter pub get
```

## Usage

### 1. VPN Status Checker

Detect if the device is connected to a VPN.

#### Dart
```dart
bool isVpnConnected = await FlutterEssential.isVpnConnected();
print('VPN Connected: \$isVpnConnected');
```

#### Output
- `true`: Device is connected to a VPN.
- `false`: No VPN connection detected.

---

### 2. Internet Connectivity Checker

Verify whether the device is connected to the internet (Wi-Fi or Mobile Data).

#### Dart
```dart
bool isInternetConnected = await FlutterEssential.isInternetConnected();
print('Internet Connected: \$isInternetConnected');
```

#### Output
- `true`: Device is connected to the internet.
- `false`: No active internet connection.

---

### 3. Package Information

Retrieve app details such as app name, package name, version, and build number.

#### Dart
```dart
PackageInfo? packageInfo = await FlutterEssential.getPackageInfo();
if (packageInfo != null) {
  print('App Name: \${packageInfo.appName}');
  print('Package Name: \${packageInfo.packageName}');
  print('Version: \${packageInfo.version}');
  print('Build Number: \${packageInfo.buildNumber}');
}
```

#### Output
```json
{
  "appName": "MyApp",
  "packageName": "com.example.myapp",
  "version": "1.0.0",
  "buildNumber": "1"
}
```

---

### 4. Device ID

Fetch the unique Android ID of the device.

#### Dart
```dart
String? deviceId = await FlutterEssential.getDeviceId();
print('Device ID: \$deviceId');
```

#### Output
- A unique string representing the Android ID of the device.

---

## Methods

| Method                   | Description                       | Returns |
|--------------------------|-----------------------------------|---------|
| `isVpnConnected()`       | Checks if VPN is active          | `bool`  |
| `isInternetConnected()`  | Checks if internet is connected  | `bool`  |
| `getPackageInfo()`       | Retrieves app package info       | `PackageInfo` |
| `getDeviceId()`          | Fetches the Android device ID    | `String` |

## Permissions

Ensure the following permissions are added to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

## Example

Here is a full example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_essential/flutter_essential.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Essential Example'),
        ),
        body: const PluginExample(),
      ),
    );
  }
}

class PluginExample extends StatefulWidget {
  const PluginExample({super.key});

  @override
  _PluginExampleState createState() => _PluginExampleState();
}

class _PluginExampleState extends State<PluginExample> {
  String vpnStatus = 'Checking...';
  String internetStatus = 'Checking...';
  String packageInfo = 'Fetching...';
  String deviceId = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    bool vpn = await FlutterEssential.isVpnConnected();
    bool internet = await FlutterEssential.isInternetConnected();
    PackageInfo? info = await FlutterEssential.getPackageInfo();
    String? id = await FlutterEssential.getDeviceId();

    setState(() {
      vpnStatus = vpn ? 'VPN Connected' : 'VPN Disconnected';
      internetStatus = internet ? 'Internet Connected' : 'No Internet';
      packageInfo = info != null
          ? 'App: \${info.appName}\nVersion: \${info.version}'
          : 'Failed to fetch package info';
      deviceId = id ?? 'Failed to fetch Device ID';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('VPN Status: \$vpnStatus'),
          Text('Internet Status: \$internetStatus'),
          Text('Package Info: \n\$packageInfo'),
          Text('Device ID: \$deviceId'),
        ],
      ),
    );
  }
}
```
