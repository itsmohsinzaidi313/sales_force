package co.devaj.sales_force.locationService;

import com.google.gson.annotations.SerializedName;

class LocationData {
    @SerializedName("user_id")
    String userId;
    @SerializedName("GpsCoordinate")
    String gpsCoordinate;
}
