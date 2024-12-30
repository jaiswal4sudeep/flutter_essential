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
