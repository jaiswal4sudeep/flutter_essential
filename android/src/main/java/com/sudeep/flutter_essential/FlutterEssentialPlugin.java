package com.sudeep.flutter_essential;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;

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
            case "getPackageInfo":
                result.success(getPackageInfo());
                break;

            case "getAndroidId":
                result.success(getAndroidId());
                break;

            case "getDeviceName":
                String deviceName = Build.MANUFACTURER + " " + Build.MODEL;
                result.success(deviceName);
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

            case "getInstallSource":
                result.success(getInstallSource());
                break;

            case "getGAID":
                getGAID(result);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private String getInstallSource() {
        try {
            return context.getPackageManager().getInstallerPackageName(context.getPackageName());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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

    // Google Advertising ID Getter
    private void getGAID(final Result result) {
        new Thread(() -> {
            try {
                AdvertisingIdClient.Info idInfo = AdvertisingIdClient.getAdvertisingIdInfo(context);
                if (idInfo != null) {
                    result.success(idInfo.getId());
                } else {
                    result.success(null);
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.error("ERROR", "Failed to get GAID", e.getMessage());
            }
        }).start();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
