# Flutter Essential Plugin

A Flutter plugin for VPN detection, internet connectivity checks, package information retrieval, and device identification.

## Features
1. **VPN Status Checker**: Detect VPN connection.
2. **Internet Connectivity Checker**: Check Wi-Fi/Mobile Data connection.
3. **Package Information**: Retrieve app metadata.
4. **Device ID**: Fetch unique Android ID.

## Installation
Add to `pubspec.yaml`:
```yaml
flutter_essential:
  git:
    url: https://github.com/Apex-Eagle-Solution-LLC/flutter_essential.git
```
Run `flutter pub get`.

## Usage

### VPN Status
```dart
bool isVpnConnected = await FlutterEssential.isVpnConnected();
```

### Internet Connectivity
```dart
bool isInternetConnected = await FlutterEssential.isInternetConnected();
```

### Package Information
```dart
PackageInfo? info = await FlutterEssential.getPackageInfo();
print(info?.appName);
```

### Device ID
```dart
String? deviceId = await FlutterEssential.getDeviceId();
```

## Example
```dart
import 'package:flutter_essential/flutter_essential.dart';

void main() async {
  bool vpn = await FlutterEssential.isVpnConnected();
  bool internet = await FlutterEssential.isInternetConnected();
  print('VPN: $vpn, Internet: $internet');
}
```

## Permissions
Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```
