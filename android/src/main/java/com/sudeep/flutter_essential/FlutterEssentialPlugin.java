package com.sudeep.flutter_essential;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;

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

            case "vibrate":
                int duration = call.argument("duration");
                vibrate(duration, result);
                break;

            case "vibrateWithPattern":
                List<Integer> pattern = call.argument("pattern");
                int repeat = call.argument("repeat");
                vibrateWithPattern(pattern, repeat, result);
                break;

            case "cancelVibration":
                cancelVibration(result);
                break;

            case "hasVibrator":
                result.success(hasVibrator());
                break;

            case "getInstallSource":
                result.success(getInstallSource());
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

    private void vibrate(int duration, Result result) {
        try {
            Vibrator vibrator = getVibrator();
            if (vibrator != null && vibrator.hasVibrator()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE));
                } else {
                    vibrator.vibrate(duration);
                }
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (Exception e) {
            result.error("VIBRATION_ERROR", "Failed to vibrate", e.getMessage());
        }
    }

    private void vibrateWithPattern(List<Integer> pattern, int repeat, Result result) {
        try {
            Vibrator vibrator = getVibrator();
            if (vibrator != null && vibrator.hasVibrator()) {
                long[] patternArray = new long[pattern.size()];
                for (int i = 0; i < pattern.size(); i++) {
                    patternArray[i] = pattern.get(i);
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createWaveform(patternArray, repeat));
                } else {
                    vibrator.vibrate(patternArray, repeat);
                }
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (Exception e) {
            result.error("VIBRATION_ERROR", "Failed to vibrate with pattern", e.getMessage());
        }
    }

    private void cancelVibration(Result result) {
        try {
            Vibrator vibrator = getVibrator();
            if (vibrator != null) {
                vibrator.cancel();
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (Exception e) {
            result.error("VIBRATION_ERROR", "Failed to cancel vibration", e.getMessage());
        }
    }

    private boolean hasVibrator() {
        Vibrator vibrator = getVibrator();
        return vibrator != null && vibrator.hasVibrator();
    }

    @SuppressLint("NewApi")
    private Vibrator getVibrator() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            VibratorManager vibratorManager = (VibratorManager) context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
            return vibratorManager.getDefaultVibrator();
        } else {
            return (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
