
# Flutter Essential Plugin

A Flutter plugin for VPN detection, internet connectivity checks, package information retrieval, device identification, emulator detection, and content sharing.

## Features
1. **VPN Status Checker**: Detect VPN connection.
2. **Internet Connectivity Checker**: Check Wi-Fi/Mobile Data connection.
3. **Package Information**: Retrieve app metadata.
4. **Device ID**: Fetch unique Android ID.
5. **Emulator Detection**: Determine if the app is running on an emulator.
6. **Share Content**: Share content to all or specific apps.

## Installation
Add the plugin to your `pubspec.yaml` file:
```yaml
flutter_essential:
  git:
    url: https://github.com/Apex-Eagle-Solution-LLC/flutter_essential.git
```

Run `flutter pub get` to fetch the package.

## Usage

### 1. VPN Status
Detect if a VPN connection is active:
```dart
bool isVpnConnected = await FlutterEssential.isVpnConnected();
print('VPN Connected: \$isVpnConnected');
```

### 2. Internet Connectivity
Check if the device is connected to the internet (Wi-Fi or Mobile Data):
```dart
bool isInternetConnected = await FlutterEssential.isInternetConnected();
print('Internet Connected: \$isInternetConnected');
```

### 3. Package Information
Retrieve app metadata, such as the app name, package name, version, and build number:
```dart
PackageInfo? info = await FlutterEssential.getPackageInfo();
print('App Name: \${info?.appName}');
print('Package Name: \${info?.packageName}');
print('Version: \${info?.version}');
print('Build Number: \${info?.buildNumber}');
```

### 4. Device ID
Fetch the unique Android device ID:
```dart
String? deviceId = await FlutterEssential.getDeviceId();
print('Device ID: \$deviceId');
```

### 5. Emulator Detection
Determine if the app is running on an emulator:
```dart
bool isEmulator = await FlutterEssential.isEmulator();
print('Running on Emulator: \$isEmulator');
```

### 6. Share Content

#### Share to All Apps
Open the "Share to All Apps" dialog to share content with any app:
```dart
await FlutterEssential.shareToAllApps(content: "Check out this amazing plugin!");
```

#### Share to Specific App
Share content to a specific app, such as WhatsApp or Telegram:
```dart
await FlutterEssential.shareToSpecificApp(
  content: "Hello from Flutter Essential!",
  app: SharingApp.whatsapp, // Replace with SharingApp.telegram for Telegram
);
```

## Example
```dart
import 'package:flutter_essential/flutter_essential.dart';

void main() async {
  bool vpn = await FlutterEssential.isVpnConnected();
  bool internet = await FlutterEssential.isInternetConnected();
  bool emulator = await FlutterEssential.isEmulator();
  
  print('VPN: \$vpn, Internet: \$internet, Emulator: \$emulator');

  await FlutterEssential.shareToAllApps(content: "Sharing to all apps!");
  await FlutterEssential.shareToSpecificApp(
    content: "Sharing to WhatsApp!",
    app: SharingApp.whatsapp,
  );
}
```

## Permissions
Add the following permissions to your `AndroidManifest.xml` file:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```