import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class FlutterEssential {
  static const MethodChannel _methodChannel =
      MethodChannel('flutter_essential');
  static final StreamController<bool> _vpnStatusController =
      StreamController<bool>.broadcast();
  static final StreamController<bool> _internetStatusController =
      StreamController<bool>.broadcast();

  //** State management for VPN status */
  static Stream<bool> get vpnStatusStream => _vpnStatusController.stream;
  static Timer? _vpnStatusTimer;

  //** State management for Internet status */
  static Stream<bool> get internetStatusStream =>
      _internetStatusController.stream;
  static Timer? _internetStatusTimer;

  //* Start VPN status updates */
  static void startVpnStatusUpdates() {
    _vpnStatusTimer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final status = await isVpnConnected();
        _vpnStatusController.add(status);
      },
    );
  }

  //* Stop VPN status updates */
  static void stopVpnStatusUpdates() {
    _vpnStatusTimer?.cancel();
    _vpnStatusTimer = null;
  }

  //* Start Internet status updates */
  static void startInternetStatusUpdates() {
    _internetStatusTimer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final status = await isInternetConnected();
        _internetStatusController.add(status);
      },
    );
  }

  //* Stop Internet status updates */
  static void stopInternetStatusUpdates() {
    _internetStatusTimer?.cancel();
    _internetStatusTimer = null;
  }

  //* Check if VPN is connected */
  static Future<bool> isVpnConnected() async {
    try {
      return await _methodChannel.invokeMethod('isVpnConnected') ?? false;
    } catch (e) {
      debugPrint('Error checking VPN status: $e');
      return false;
    }
  }

  //* Check if Internet is connected */
  static Future<bool> isInternetConnected() async {
    try {
      return await _methodChannel.invokeMethod('isInternetConnected') ?? false;
    } catch (e) {
      debugPrint('Error checking Internet status: $e');
      return false;
    }
  }

  //* Get package information */
  static Future<PackageInfo> getPackageInfo() async {
    try {
      final result =
          await _methodChannel.invokeMethod<String>('getPackageInfo');
      if (result != null) {
        final Map<String, dynamic> parsedResult = jsonDecode(result);
        return PackageInfo.fromMap(parsedResult);
      }
      return PackageInfo(
        appName: '',
        packageName: '',
        version: '',
        buildNumber: '',
      );
    } catch (e) {
      debugPrint('Error fetching package info: $e');
      return PackageInfo(
        appName: '',
        packageName: '',
        version: '',
        buildNumber: '',
      );
    }
  }

  //* Get Device id */
  static Future<String> getDeviceId() async {
    try {
      return await _methodChannel.invokeMethod('getAndroidId') ?? '';
    } catch (e) {
      debugPrint('Error fetching device id: $e');
      return '';
    }
  }

  //* Get Device Name */
  static Future<String> getDeviceName() async {
    try {
      return await _methodChannel.invokeMethod('getDeviceName') ?? '';
    } catch (e) {
      debugPrint('Error fetching device name: $e');
      return '';
    }
  }

  //* Share content to all apps */
  static Future<void> shareToAllApps({
    required String content,
  }) async {
    final Map<String, dynamic> arguments = {
      'content': content,
    };

    await _methodChannel.invokeMethod('shareToAllApps', arguments);
  }

  //* Share content to specific app */
  static Future<void> shareToSpecificApp({
    required String content,
    required SharingApp app,
  }) async {
    final Map<String, dynamic> arguments = {
      'content': content,
      'app': app.packageName,
    };

    await _methodChannel.invokeMethod('shareToSpecificApp', arguments);
  }

  //* Open app using package name */
  static Future<void> openApp({
    required String packageName,
  }) async {
    final Map<String, dynamic> arguments = {
      'content': 'test',
      'app': packageName,
    };

    await _methodChannel.invokeMethod('shareToSpecificApp', arguments);
  }

  /// Vibration Methods

  /// Vibrates the device for [duration] milliseconds
  static Future<void> vibrate({required int duration}) async {
    try {
      await _methodChannel.invokeMethod('vibrate', {'duration': duration});
    } on PlatformException catch (e) {
      debugPrint('Failed to vibrate: ${e.message}');
    }
  }

  /// Vibrates the device with a custom pattern
  /// [pattern] - List of durations in milliseconds (wait, vibrate, wait, vibrate...)
  /// [repeat] - Index at which to repeat the pattern (-1 for no repeat)
  static Future<void> vibrateWithPattern({
    required List<int> pattern,
    required int repeat,
  }) async {
    try {
      await _methodChannel.invokeMethod('vibrateWithPattern', {
        'pattern': pattern,
        'repeat': repeat,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to vibrate with pattern: ${e.message}');
    }
  }

  /// Cancels any ongoing vibration
  static Future<void> cancelVibration() async {
    try {
      await _methodChannel.invokeMethod('cancelVibration');
    } on PlatformException catch (e) {
      debugPrint('Failed to cancel vibration: ${e.message}');
    }
  }

  /// Checks if the device has a vibrator
  static Future<bool> hasVibrator() async {
    try {
      return await _methodChannel.invokeMethod('hasVibrator') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check vibrator: ${e.message}');
      return false;
    }
  }

  /// Convenience method for short feedback vibration
  static Future<void> lightVibration() async {
    if (await hasVibrator()) {
      await vibrate(duration: 50);
    }
  }

  /// Convenience method for medium feedback vibration
  static Future<void> mediumVibration() async {
    if (await hasVibrator()) {
      await vibrate(duration: 110);
    }
  }

  /// Convenience method for long feedback vibration
  static Future<void> heavyVibration() async {
    if (await hasVibrator()) {
      await vibrate(duration: 200);
    }
  }

  static Future<String> getInstallSource() async {
    try {
      return await _methodChannel.invokeMethod('getInstallSource') ?? '';
    } catch (e) {
      debugPrint('Error fetching install source: $e');
      return '';
    }
  }

  ///  Get Advertising ID
  static Future<String> getAdvertisingId() async {
    try {
      return await _methodChannel.invokeMethod('getGAID') ?? '';
    } catch (e) {
      debugPrint('Error fetching advertising ID: $e');
      return '';
    }
  }
}
