package co.devaj.sales_force.locationService;

import co.devaj.sales_force.Config;
import co.devaj.sales_force.ServerResponse;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

interface LocationApi {
    @POST("")
    Call<ServerResponse> postLocation(@Body LocationData locationData);
}
