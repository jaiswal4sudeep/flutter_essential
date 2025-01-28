package com.adzvortex.flutter_essential;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;
import java.io.IOException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterEssentialPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_essential");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "isVpnConnected":
                result.success(isVpnConnected());
                break;

            case "getPackageInfo":
                result.success(getPackageInfo());
                break;

            case "isInternetConnected":
                result.success(isInternetConnected());
                break;

            case "getAndroidId":
                result.success(getAndroidId());
                break;

            case "isEmulator": // New case for isEmulator
                result.success(isEmulator());
                break;

            case "shareToSpecificApp":
                String content = call.argument("content");
                String app = call.argument("app");
                shareToSpecificApp(content, app, result);
                break;

            case "shareToAllApps":
                String allContent = call.argument("content");
                shareToAllApps(allContent, result);
                break;

            case "openApp":
                String packageName = call.argument("package");
                openApp(packageName, result);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    // VPN Connectivity Checker
    private boolean isVpnConnected() {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            for (Network network : connectivityManager.getAllNetworks()) {
                NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
                if (capabilities != null && capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)) {
                    return true;
                }
            }
        }

        try {
            List<NetworkInterface> networkInterfaces = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface networkInterface : networkInterfaces) {
                if (networkInterface.isUp() && networkInterface.getName().contains("tun")) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Internet Connectivity Checker
    private boolean isInternetConnected() {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            Network activeNetwork = connectivityManager.getActiveNetwork();
            if (activeNetwork != null) {
                NetworkCapabilities networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork);
                if (networkCapabilities != null) {
                    return networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                            (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                                    networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR));
                }
            }
        }
        return false;
    }

    // Package Info Getter
    private String getPackageInfo() {
        try {
            String appName = context.getApplicationInfo().loadLabel(context.getPackageManager()).toString();
            String packageName = context.getPackageName();
            String version = context.getPackageManager().getPackageInfo(packageName, 0).versionName;
            int buildNumber = context.getPackageManager().getPackageInfo(packageName, 0).versionCode;

            return "{" +
                    "\"appName\":\"" + appName + "\"," +
                    "\"packageName\":\"" + packageName + "\"," +
                    "\"version\":\"" + version + "\"," +
                    "\"buildNumber\":\"" + buildNumber + "\"}";
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Android ID Getter
    @SuppressLint("HardwareIds")
    private String getAndroidId() {
        try {
            return Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Check if the device is an emulator
    private boolean isEmulator() {
        return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_google")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator");
    }

    // Share content to a specific app
    private void shareToSpecificApp(String content, String packageName, Result result) {
        try {
            Log.d("FlutterEssentialPlugin", "App: " + packageName + " | Content: " + content);

            Intent intent = new Intent(Intent.ACTION_SEND);
            intent.setType("text/plain");
            intent.putExtra(Intent.EXTRA_TEXT, content);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setPackage(packageName);

            try {
                context.startActivity(intent);
                result.success(null);
            } catch (android.content.ActivityNotFoundException ex) {
                result.error("APP_NOT_FOUND", "App is not installed.", null);
            } catch (Exception e) {
                result.error("ERROR", "Error sharing content.", e.getMessage());
            }
        } catch (Exception e) {
            Log.e("FlutterEssentialPlugin", "Error sharing content to package: " + packageName, e);
            result.error("ERROR", "Error sharing content.", e.getMessage());
        }
    }

    // Share content to all apps (Open with dialog)
    private void shareToAllApps(String content, Result result) {
        try {
            Intent intent = new Intent(Intent.ACTION_SEND);
            intent.setType("text/plain");
            intent.putExtra(Intent.EXTRA_TEXT, content);
            Intent chooser = Intent.createChooser(intent, "Share using");
            chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(chooser);
            result.success(null);
        } catch (Exception e) {
            e.printStackTrace();
            result.error("ERROR", "Error sharing content.", e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
