import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency
import Security

public class SwiftFlutterEssential: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_essential", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterEssential()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPackageInfo":
      result(self.getPackageInfo())
    case "getAndroidId":
      // ✅ Replaced with permanent Keychain-based ID
      result(self.getPermanentDeviceID())
    case "getDeviceName":
      result(UIDevice.current.name)
    case "shareToSpecificApp":
      if let args = call.arguments as? [String:Any], let content = args["content"] as? String, let app = args["app"] as? String {
        self.shareToSpecificApp(content: content, app: app, result: result)
      } else {
        result(FlutterError(code: "BAD_ARGS", message: "content/app missing", details: nil))
      }
    case "shareToAllApps":
      if let args = call.arguments as? [String:Any], let content = args["content"] as? String {
        self.shareToAllApps(content: content, result: result)
      } else {
        result(FlutterError(code: "BAD_ARGS", message: "content missing", details: nil))
      }
    case "getInstallSource":
      result("App Store")
    case "getGAID":
      self.getIDFA(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - App Info
  private func getPackageInfo() -> String {
    let bundle = Bundle.main
    let displayName = (bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ??
                      (bundle.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""
    let packageName = bundle.bundleIdentifier ?? ""
    let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    let json = [
      "appName": displayName,
      "packageName": packageName,
      "version": version,
      "buildNumber": build
    ]
    if let data = try? JSONSerialization.data(withJSONObject: json, options: []),
       let s = String(data: data, encoding: .utf8) {
      return s
    }
    return "{}"
  }

  // MARK: - Permanent Device ID (Keychain based)
  private func getPermanentDeviceID() -> String {
    let key = "com.flutteressential.permanentDeviceID"

    if let existing = KeychainHelper.shared.get(forKey: key) {
      return existing
    }

    let newId = UUID().uuidString
    KeychainHelper.shared.set(newId, forKey: key)
    return newId
  }

  // MARK: - Share Functions
  private func shareToAllApps(content: String, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
        result(FlutterError(code: "NO_UI", message: "No root view controller", details: nil))
        return
      }
      let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = vc.view
      vc.present(activityVC, animated: true) {
        result(nil)
      }
    }
  }

  private func shareToSpecificApp(content: String, app: String, result: @escaping FlutterResult) {
    let scheme = schemeForPackageName(app)
    DispatchQueue.main.async {
      guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
        result(FlutterError(code: "NO_UI", message: "No root view controller", details: nil))
        return
      }

      if let base = scheme, !base.isEmpty, let url = self.buildShareUrl(for: base, content: content), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:]) { success in
          result(success)
        }
        return
      }

      let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = vc.view
      vc.present(activityVC, animated: true) {
        result(nil)
      }
    }
  }

  private func schemeForPackageName(_ pkg: String) -> String? {
    switch pkg {
    case "com.whatsapp":
      return "whatsapp"
    case "org.telegram.messenger":
      return "tg"
    case "com.instagram.android":
      return "instagram"
    case "com.facebook.orca":
      return "fb-messenger"
    case "com.twitter.android":
      return "twitter"
    default:
      return nil
    }
  }

  private func buildShareUrl(for scheme: String, content: String) -> URL? {
    let encoded = content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    switch scheme {
    case "whatsapp":
      return URL(string: "whatsapp://send?text=\(encoded)")
    case "tg":
      return URL(string: "tg://msg?text=\(encoded)")
    case "instagram":
      return URL(string: "instagram://app")
    case "fb-messenger":
      return URL(string: "fb-messenger://share?text=\(encoded)")
    default:
      return nil
    }
  }

  // MARK: - IDFA
  private func getIDFA(result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        if status == .authorized {
          let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          if idfa == "00000000-0000-0000-0000-000000000000" {
            result("")
          } else {
            result(idfa)
          }
        } else {
          result("")
        }
      }
    } else {
      if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        result(idfa == "00000000-0000-0000-0000-000000000000" ? "" : idfa)
      } else {
        result("")
      }
    }
  }
}

// MARK: - Keychain Helper
class KeychainHelper {
  static let shared = KeychainHelper()

  func set(_ value: String, forKey key: String) {
    let data = value.data(using: .utf8)!
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data
    ] as CFDictionary

    SecItemDelete(query)
    SecItemAdd(query, nil)
  }

  func get(forKey key: String) -> String? {
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne
    ] as CFDictionary

    var result: AnyObject?
    SecItemCopyMatching(query, &result)

    guard let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }
}
