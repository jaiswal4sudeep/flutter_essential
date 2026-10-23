import 'package:flutter/material.dart';
import 'package:flutter_essential/flutter_essential.dart';
import 'package:flutter_essential/model.dart';

void main() {
  runApp(const PluginTestApp());
}

class PluginTestApp extends StatelessWidget {
  const PluginTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Essential Plugin Tester',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PluginTestPage(),
    );
  }
}

class PluginTestPage extends StatefulWidget {
  const PluginTestPage({super.key});

  @override
  State<PluginTestPage> createState() => _PluginTestPageState();
}

class _PluginTestPageState extends State<PluginTestPage> {
  String _packageInfo = 'Not fetched';
  String _deviceId = 'Not fetched';
  String _deviceName = 'Not fetched';
  String _realDevice = 'Not checked';
  String _developerMode = 'Not checked';
  String _usbDebugging = 'Not checked';
  String _installSource = 'Not fetched';
  String _advertisingId = 'Not fetched';
  String _lastAction = 'Idle';
  final List<String> _log = [];

  void _appendLog(String s) {
    setState(() {
      _log.insert(0, '${DateTime.now().toIso8601String()} — $s');
    });
  }

  Future<void> _fetchPackageInfo() async {
    setState(() => _lastAction = 'Fetching package info...');
    try {
      final info = await FlutterEssential.getPackageInfo();
      setState(
        () =>
            _packageInfo =
                'appName: ${info.appName}, package: ${info.packageName}, version: ${info.version}, build: ${info.buildNumber}',
      );
      _appendLog('getPackageInfo success: $_packageInfo');
    } catch (e) {
      setState(() => _packageInfo = 'Error: $e');
      _appendLog('getPackageInfo error: $e');
    }
  }

  Future<void> _fetchDeviceId() async {
    setState(() => _lastAction = 'Fetching device id...');
    try {
      final id = await FlutterEssential.getDeviceId();
      setState(() => _deviceId = id.isEmpty ? '(empty)' : id);
      _appendLog('getDeviceId: $_deviceId');
    } catch (e) {
      setState(() => _deviceId = 'Error: $e');
      _appendLog('getDeviceId error: $e');
    }
  }

  Future<void> _fetchDeviceName() async {
    setState(() => _lastAction = 'Fetching device name...');
    try {
      final name = await FlutterEssential.getDeviceName();
      setState(() => _deviceName = name.isEmpty ? '(empty)' : name);
      _appendLog('getDeviceName: $_deviceName');
    } catch (e) {
      setState(() => _deviceName = 'Error: $e');
      _appendLog('getDeviceName error: $e');
    }
  }

  Future<void> _checkRealDevice() async {
    setState(() => _lastAction = 'Checking physical device...');
    try {
      final value = await FlutterEssential.isRealDevice();
      setState(() => _realDevice = value.toString());
      _appendLog('isRealDevice: $_realDevice');
    } catch (e) {
      setState(() => _realDevice = 'Error: $e');
      _appendLog('isRealDevice error: $e');
    }
  }

  Future<void> _checkDeveloperMode() async {
    setState(() => _lastAction = 'Checking developer mode...');
    try {
      final value = await FlutterEssential.isDeveloperModeEnabled();
      setState(() => _developerMode = value.toString());
      _appendLog('isDeveloperModeEnabled: $_developerMode');
    } catch (e) {
      setState(() => _developerMode = 'Error: $e');
      _appendLog('isDeveloperModeEnabled error: $e');
    }
  }

  Future<void> _checkUsbDebugging() async {
    setState(() => _lastAction = 'Checking USB debugging...');
    try {
      final value = await FlutterEssential.isUsbDebuggingEnabled();
      setState(() => _usbDebugging = value.toString());
      _appendLog('isUsbDebuggingEnabled: $_usbDebugging');
    } catch (e) {
      setState(() => _usbDebugging = 'Error: $e');
      _appendLog('isUsbDebuggingEnabled error: $e');
    }
  }

  Future<void> _shareToAll() async {
    setState(() => _lastAction = 'Sharing to all apps...');
    try {
      await FlutterEssential.shareToAllApps(
        content: 'Hello from FlutterEssential test!',
      );
      _appendLog('shareToAllApps invoked');
      _showSnack('shareToAllApps invoked');
    } catch (e) {
      _appendLog('shareToAllApps error: $e');
      _showSnack('shareToAllApps error: $e');
    }
  }

  Future<void> _shareToSpecific(SharingApp app) async {
    setState(() => _lastAction = 'Sharing to ${app.name}...');
    try {
      await FlutterEssential.shareToSpecificApp(
        content: 'Test share to ${app.name} from FlutterEssential',
        app: app,
      );
      _appendLog('shareToSpecificApp invoked for ${app.packageName}');
      _showSnack('shareToSpecificApp invoked for ${app.name}');
    } catch (e) {
      _appendLog('shareToSpecificApp error: $e');
      _showSnack('shareToSpecificApp error: $e');
    }
  }

  Future<void> _openApp(String packageName) async {
    setState(() => _lastAction = 'Opening app $packageName...');
    try {
      await FlutterEssential.openApp(packageName: packageName);
      _appendLog('openApp invoked for $packageName');
      _showSnack('openApp invoked for $packageName');
    } catch (e) {
      _appendLog('openApp error: $e');
      _showSnack('openApp error: $e');
    }
  }

  Future<void> _fetchInstallSource() async {
    setState(() => _lastAction = 'Fetching install source...');
    try {
      final src = await FlutterEssential.getInstallSource();
      setState(() => _installSource = src.isEmpty ? '(empty)' : src);
      _appendLog('getInstallSource: $_installSource');
    } catch (e) {
      setState(() => _installSource = 'Error: $e');
      _appendLog('getInstallSource error: $e');
    }
  }

  Future<void> _fetchAdvertisingId() async {
    setState(() => _lastAction = 'Fetching advertising ID...');
    try {
      final id = await FlutterEssential.getAdvertisingId();
      setState(() => _advertisingId = id.isEmpty ? '(empty)' : id);
      _appendLog('getAdvertisingId: $_advertisingId');
    } catch (e) {
      setState(() => _advertisingId = 'Error: $e');
      _appendLog('getAdvertisingId error: $e');
    }
  }

  Future<void> _runAllTests() async {
    setState(() => _lastAction = 'Running all tests...');
    _appendLog('=== Run all started ===');
    await _fetchPackageInfo();
    await _fetchDeviceId();
    await _fetchDeviceName();
    await _checkRealDevice();
    await _checkDeveloperMode();
    await _checkUsbDebugging();
    // share functions will open share sheet / external apps; call them but note user interaction might be required
    await _shareToAll();
    await _shareToSpecific(SharingApp.whatsapp);
    await _openApp(SharingApp.whatsapp.packageName);
    await _fetchInstallSource();
    await _fetchAdvertisingId();
    _appendLog('=== Run all finished ===');
    setState(() => _lastAction = 'All tests finished');
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _smallButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterEssential Plugin Tester'),
        actions: [
          IconButton(
            tooltip: 'Run all tests',
            onPressed: _runAllTests,
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Last action: $_lastAction'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick actions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: _fetchPackageInfo,
                                child: const Text('getPackageInfo'),
                              ),
                              ElevatedButton(
                                onPressed: _fetchDeviceId,
                                child: const Text('getDeviceId'),
                              ),
                              ElevatedButton(
                                onPressed: _fetchDeviceName,
                                child: const Text('getDeviceName'),
                              ),
                              ElevatedButton(
                                onPressed: _fetchInstallSource,
                                child: const Text('getInstallSource'),
                              ),
                              ElevatedButton(
                                onPressed: _fetchAdvertisingId,
                                child: const Text('getAdvertisingId'),
                              ),
                              ElevatedButton(
                                onPressed: _checkRealDevice,
                                child: const Text('isRealDevice'),
                              ),
                              ElevatedButton(
                                onPressed: _checkDeveloperMode,
                                child: const Text('isDeveloperModeEnabled'),
                              ),
                              ElevatedButton(
                                onPressed: _checkUsbDebugging,
                                child: const Text('isUsbDebuggingEnabled'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Share / Open testing',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _smallButton('shareToAllApps', _shareToAll),
                          _smallButton(
                            'shareToSpecificApp (WhatsApp)',
                            () => _shareToSpecific(SharingApp.whatsapp),
                          ),
                          _smallButton(
                            'shareToSpecificApp (Telegram)',
                            () => _shareToSpecific(SharingApp.telegram),
                          ),
                          _smallButton(
                            'openApp (WhatsApp pkg)',
                            () => _openApp(SharingApp.whatsapp.packageName),
                          ),
                          _smallButton(
                            'openApp (Instagram pkg)',
                            () => _openApp(SharingApp.instagram.packageName),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Results',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('PackageInfo: $_packageInfo'),
                          const SizedBox(height: 6),
                          Text('DeviceId: $_deviceId'),
                          const SizedBox(height: 6),
                          Text('DeviceName: $_deviceName'),
                          const SizedBox(height: 6),
                          Text('RealDevice: $_realDevice'),
                          const SizedBox(height: 6),
                          Text('DeveloperMode: $_developerMode'),
                          const SizedBox(height: 6),
                          Text('UsbDebugging: $_usbDebugging'),
                          const SizedBox(height: 6),
                          Text('InstallSource: $_installSource'),
                          const SizedBox(height: 6),
                          Text('AdvertisingId: $_advertisingId'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Log (most recent first)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 240,
                            child:
                                _log.isEmpty
                                    ? const Center(child: Text('No logs yet'))
                                    : ListView.builder(
                                      itemCount: _log.length,
                                      itemBuilder:
                                          (context, idx) => Text(_log[idx]),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
