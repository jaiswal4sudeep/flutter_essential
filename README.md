# Flutter Essential Plugin

`flutter_essential` is a Flutter plugin designed to provide essential utility functions including VPN and internet status monitoring, device information retrieval, content sharing, app launching, and vibration controls — all through a single, clean API.

## 🔧 Features

- Check **VPN** and **Internet** connectivity
- Retrieve **device information** like ID and name
- Access **app package info**
- **Share content** to all or specific apps
- **Launch apps** using package name
- Use advanced **vibration** features (with patterns, feedback types)
- Real-time stream updates for VPN and Internet status

---

## 🚀 Getting Started

### 1. Import the package

```dart
import 'package:flutter_essential/flutter_essential.dart';
```

---

## 📡 Connectivity Monitoring

### Start/Stop VPN Status Stream

```dart
FlutterEssential.startVpnStatusUpdates();
FlutterEssential.vpnStatusStream.listen((isConnected) {
  print('VPN Connected: $isConnected');
});

// To stop:
FlutterEssential.stopVpnStatusUpdates();
```

### Start/Stop Internet Status Stream

```dart
FlutterEssential.startInternetStatusUpdates();
FlutterEssential.internetStatusStream.listen((isConnected) {
  print('Internet Connected: $isConnected');
});

// To stop:
FlutterEssential.stopInternetStatusUpdates();
```

---

## 📱 Device Information

```dart
final deviceId = await FlutterEssential.getDeviceId();
final deviceName = await FlutterEssential.getDeviceName();
final packageInfo = await FlutterEssential.getPackageInfo();
```

---

## 📤 Sharing Content

### Share to All Apps

```dart
await FlutterEssential.shareToAllApps(content: "Hello!");
```

### Share to Specific App

```dart
await FlutterEssential.shareToSpecificApp(
  content: "Hello!",
  app: SharingApp.whatsapp, // example
);
```

---

## 🚀 Launch App by Package Name

```dart
await FlutterEssential.openApp(packageName: "com.example.app");
```

---

## 📳 Vibration Features

### Basic Vibration

```dart
await FlutterEssential.vibrate(duration: 100);
```

### Pattern Vibration

```dart
await FlutterEssential.vibrateWithPattern(
  pattern: [0, 100, 50, 200],
  repeat: -1,
);
```

### Cancel Vibration

```dart
await FlutterEssential.cancelVibration();
```

### Predefined Feedback

```dart
await FlutterEssential.lightVibration();
await FlutterEssential.mediumVibration();
await FlutterEssential.heavyVibration();
```

---

## 📦 Package Info Structure

```dart
class PackageInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  PackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
}
```

---

## 🛠 Platform Integration

Ensure proper method channels are implemented on Android and iOS as needed.

---

## 📃 License

MIT License
