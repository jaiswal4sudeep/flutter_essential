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

  factory PackageInfo.fromMap(Map<String, dynamic> map) {
    return PackageInfo(
      appName: map['appName'] ?? '',
      packageName: map['packageName'] ?? '',
      version: map['version'] ?? '',
      buildNumber: map['buildNumber'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}

// Enum for specific apps to share content
enum SharingApp {
  whatsapp,
  telegram,
  facebookMessenger,
  instagramDirect;

  String get packageName {
    switch (this) {
      case SharingApp.whatsapp:
        return 'com.whatsapp';
      case SharingApp.telegram:
        return 'org.telegram.messenger';
      case SharingApp.facebookMessenger:
        return 'com.facebook.orca';
      case SharingApp.instagramDirect:
        return 'com.instagram.android';
    }
  }
}
