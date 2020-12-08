package co.devaj.sales_force;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import co.devaj.sales_force.locationService.LocationService;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("location", "LocationService", NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            manager.createNotificationChannel(channel);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        final String LOCATION_SERVICE_CHANNEL = "com.devaj.ddf/locationService";
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), LOCATION_SERVICE_CHANNEL).setMethodCallHandler((call, result) -> {
            Intent serviceIntent = new Intent(this, LocationService.class);
            if (call.method.equals("start")) {
                Map<String, String> arguments = call.arguments();
                Config.userId = arguments.get("user_id");
                Config.trackingApi = arguments.get("trackingApi");

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(serviceIntent);
                } else {
                    startService(serviceIntent);
                }
                Log.d("Location Service", "Location service started");
            } else if (call.method.equals("stop")) {
                Log.d("Location Service", "Location service stopped");
            } else {
                Log.d("Location Service", "Invalid method call");
            }
        });
    }
}
