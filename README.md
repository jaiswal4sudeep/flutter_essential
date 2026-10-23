# Flutter Essential

`flutter_essential` is an Android Flutter plugin for reading app and device
information, sharing text, opening supported apps, detecting emulators, and
checking Developer options and USB debugging.

## Features

- Read the app name, package name, version and build number
- Read a device identifier and device name
- Check whether an Android device appears to be a physical device
- Check whether Developer options are enabled
- Check whether USB debugging is enabled
- Read the app's install source
- Read the Google Advertising ID on Android
- Share text with all apps or with a supported app
- Open a supported app using its package name

> VPN, internet-status and vibration APIs are not part of the current public
> API.

## Getting started

Add `flutter_essential` to your `pubspec.yaml`, then import the plugin:

```dart
import 'package:flutter_essential/flutter_essential.dart';
```

Import the model library as well when using `PackageInfo` or `SharingApp`:

```dart
import 'package:flutter_essential/model.dart';
```

## API reference

### Package information

```dart
final PackageInfo info = await FlutterEssential.getPackageInfo();

print(info.appName);
print(info.packageName);
print(info.version);
print(info.buildNumber);
```

`getPackageInfo()` returns:

| Field | Type | Description |
| --- | --- | --- |
| `appName` | `String` | User-visible application name |
| `packageName` | `String` | Android application ID |
| `version` | `String` | User-visible app version |
| `buildNumber` | `String` | Internal build/version number |

If package information cannot be read, every field is returned as an empty
string.

### Device ID

```dart
final String deviceId = await FlutterEssential.getDeviceId();
```

- Returns `Settings.Secure.ANDROID_ID`.
- Returns an empty string if the value cannot be read.

The value should be treated as an app/device-scoped identifier, not as a
guaranteed permanent hardware serial number.

### Device name

```dart
final String deviceName = await FlutterEssential.getDeviceName();
```

- Returns the manufacturer and model, for example `Google Pixel 8`.
- Returns an empty string if the value cannot be read.

### Physical device detection

```dart
final bool isPhysicalDevice = await FlutterEssential.isRealDevice();
```

On Android, the plugin inspects build properties including the fingerprint,
model, manufacturer, brand, device and product:

- Returns `false` when those values contain known emulator indicators such as
  `generic`, `google_sdk`, `emulator`, `sdk_x86`, `vbox86p`, `genymotion` or
  `simulator`.
- Returns `true` when none of the configured emulator indicators are found.
- Returns `false` if the native call fails.

This is heuristic detection, so `true` means "not recognized as an emulator"
rather than absolute proof that the device is physical.

### Developer options status

```dart
final bool developerModeEnabled =
    await FlutterEssential.isDeveloperModeEnabled();
```

- Returns `true` when Android Developer options are enabled.
- Returns `false` when Developer options are disabled or the setting cannot be
  read.

### USB debugging status

```dart
final bool usbDebuggingEnabled =
    await FlutterEssential.isUsbDebuggingEnabled();
```

- Returns `true` when the Android **USB debugging** (`ADB_ENABLED`) setting is
  enabled.
- Returns `false` when USB debugging is disabled or the setting cannot be read.

This reports the setting's state. It does not indicate whether a USB cable is
connected, whether an ADB computer is authorized, or whether an active ADB
session exists.

### Install source

```dart
final String installSource = await FlutterEssential.getInstallSource();
```

Returns the installer package name, such as `com.android.vending` for Google
Play. It can be empty for a sideloaded app or when the installer cannot be
determined.

### Advertising ID

```dart
final String advertisingId = await FlutterEssential.getAdvertisingId();
```

Returns the Google Advertising ID (GAID), or an empty string when the ID cannot
be obtained. Advertising IDs are privacy-sensitive and may be unavailable or
reset by the user.

### Share text with all apps

```dart
await FlutterEssential.shareToAllApps(
  content: 'Hello from Flutter Essential!',
);
```

This opens the platform share UI with the supplied plain text.

### Share text with a specific app

```dart
await FlutterEssential.shareToSpecificApp(
  content: 'Hello!',
  app: SharingApp.whatsapp,
);
```

Supported `SharingApp` values are:

- `SharingApp.whatsapp`
- `SharingApp.telegram`
- `SharingApp.instagram`
- `SharingApp.facebookMessenger`
- `SharingApp.twitter`

An `APP_NOT_FOUND` platform error is returned when the selected app is not
installed.

### Open an app by package name

```dart
await FlutterEssential.openApp(
  packageName: SharingApp.whatsapp.packageName,
);
```

`openApp()` currently routes through the plugin's specific-app share action and
sends `Hello` as plain text. Consequently, it opens the target app's share flow
rather than guaranteeing that the app's normal launch screen is shown.

## Platform support

This plugin currently supports Android only.

## PackageInfo model

```dart
class PackageInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
}
```

## License

MIT License
