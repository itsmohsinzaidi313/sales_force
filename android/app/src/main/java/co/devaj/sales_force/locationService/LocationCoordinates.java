package co.devaj.sales_force.locationService;

import com.google.gson.annotations.SerializedName;

class LocationCoordinates {
    @SerializedName("long")
    String longitude;
    @SerializedName("time")
    String time;
    @SerializedName("lat")
    String latitude;
}
