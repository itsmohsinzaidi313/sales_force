package co.devaj.sales_force.locationService;

import android.app.Service;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

import com.google.gson.Gson;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import androidx.core.app.NotificationCompat;
import co.devaj.sales_force.Config;

public class LocationService extends Service implements LocationListener {
    public LocationService() {
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder builder = new NotificationCompat.Builder(LocationService.this, "orders")
                    .setContentText("Location service is running background")
                    .setContentTitle("DDF");
            try {
                startForeground(1, builder.build());
            } catch (Exception e) {
                Log.e("Order Service", e.getMessage());
            }
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onLocationChanged(Location location) {
        LocationData locationData = new LocationData();
        locationData.userId = Config.userId;

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat mdformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LocationCoordinates coordinates = new LocationCoordinates();
        coordinates.latitude = String.valueOf(location.getLatitude());
        coordinates.longitude = String.valueOf(location.getLongitude());
        coordinates.time = mdformat.format(calendar.getTime());

        locationData.gpsCoordinate = new Gson().toJson(coordinates, LocationCoordinates.class);


    }

    @Override
    public void onStatusChanged(String s, int i, Bundle bundle) {

    }

    @Override
    public void onProviderEnabled(String s) {

    }

    @Override
    public void onProviderDisabled(String s) {

    }
}
