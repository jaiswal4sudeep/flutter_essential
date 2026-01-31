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

enum SharingApp {
  whatsapp,
  telegram,
  instagram,
  facebookMessenger,
  twitter;

  String get packageName {
    switch (this) {
      case SharingApp.whatsapp:
        return 'com.whatsapp';
      case SharingApp.telegram:
        return 'org.telegram.messenger';
      case SharingApp.instagram:
        return 'com.instagram.android';
      case SharingApp.facebookMessenger:
        return 'com.facebook.orca';
      case SharingApp.twitter:
        return 'com.twitter.android';
    }
  }
}
