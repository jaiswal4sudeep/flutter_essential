import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class FlutterEssential {
  static const MethodChannel _methodChannel =
      MethodChannel('flutter_essential');

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
      if (Platform.isAndroid) {
        return await _methodChannel.invokeMethod('getGAID') ?? '';
      }
      return '';
    } catch (e) {
      debugPrint('Error fetching advertising ID: $e');
      return '';
    }
  }
}
