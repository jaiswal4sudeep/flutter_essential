# Flutter Essential Plugin

A Flutter plugin for VPN detection, internet connectivity checks, package information retrieval, device identification, and sharing content.

## Features
1. **VPN Status Checker**: Detect VPN connection.
2. **Internet Connectivity Checker**: Check Wi-Fi/Mobile Data connection.
3. **Package Information**: Retrieve app metadata.
4. **Device ID**: Fetch unique Android ID.
5. **Share Content**: Share content to all or specific apps.

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

### Share Content

#### Share to All Apps
Opens the "Share to All Apps" dialog.
```dart
await FlutterEssential.shareToAllApps(content: "Check out this amazing plugin!");
```

#### Share to Specific App
Shares content to a specific app, such as WhatsApp or Telegram.
```dart
await FlutterEssential.shareToSpecificApp(
  content: "Hello from Flutter Essential!",
  app: SharingApp.whatsapp, // Use SharingApp.telegram for Telegram
);
```

## Example
```dart
import 'package:flutter_essential/flutter_essential.dart';

void main() async {
  bool vpn = await FlutterEssential.isVpnConnected();
  bool internet = await FlutterEssential.isInternetConnected();
  print('VPN: $vpn, Internet: $internet');

  await FlutterEssential.shareToAllApps(content: "Sharing to all apps!");
  await FlutterEssential.shareToSpecificApp(
    content: "Sharing to WhatsApp!",
    app: SharingApp.whatsapp,
  );
}
```

## Permissions
Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```
