package com.google.tafweej.tafweej;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.firebase.client.Firebase;

import org.w3c.dom.Text;

import java.util.HashMap;

public class MainActivity extends AppCompatActivity {

    private final int MY_PERMISSIONS_REQUEST_LOCATION = 1;
    LocationManager locationManager;
    LocationListener locationListener;
    double lat = 0;
    double lon = 0;
    Tafweej tafweej;
    int progressValue;

    SeekBar seekBar;
    TextView textViewNumberofHaj;
    Button buttonStart;
    Button buttonStop;
    Firebase mRef;
    Firebase  child;
    HashMap<Object,Object> mLocation;
    String numberOfHaj ="Number of Haj is ";
    TextView textViewCrowdId;
    HashMap<Object,Object> crowdData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        seekBar = (SeekBar)findViewById(R.id.seekBar);
        textViewNumberofHaj = (TextView) findViewById(R.id.textViewNumberofHaj);
        buttonStart = (Button) findViewById(R.id.buttonStart);
        buttonStop = (Button) findViewById(R.id.buttonStop);
        textViewCrowdId = (TextView) findViewById(R.id.textViewCrowdId);
        setSeekBar();


        mLocation = new HashMap<>();
        crowdData = new HashMap<>();
        tafweej = Tafweej.getInstance();
        mRef = new Firebase("https://lino2018-ad380.firebaseio.com/");
        Logging.write ("Crowd_id==== "+tafweej.getCrowd_id());
        child = mRef.child("Crowd").child(tafweej.getCrowd_id());
        textViewCrowdId.setText("Crowd ID : "+tafweej.getCrowd_id());

    }


    public void setSeekBar(){

        textViewNumberofHaj.setText(numberOfHaj +seekBar.getProgress() +"/"+ seekBar.getMax());
        seekBar.setMax(300);
        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                progressValue = i;
                textViewNumberofHaj.setText(numberOfHaj +progressValue +"/"+ seekBar.getMax());

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                textViewNumberofHaj.setText(numberOfHaj +progressValue +"/"+ seekBar.getMax());


            }
        });
    }

    public void getLocation() {

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        if (locationManager != null){

            buttonStop.setVisibility(View.VISIBLE);
            buttonStart.setVisibility(View.INVISIBLE);
            tafweej.setStatus("Active");
            crowdData.put("numberOfPeople", progressValue);
            seekBar.setEnabled(false);

        }

        locationListener = new LocationListener() {

            @Override
            public void onLocationChanged(Location location) {
                lat = location.getLatitude();
                lon = location.getLongitude();
                Logging.write("lat: " + lat + " lon :" + lon);


                mLocation.put("lat",lat);
                mLocation.put("lng",lon);
                crowdData.put("campaign_id", tafweej.getCampaign_id());
                crowdData.put("location",mLocation);
                crowdData.put("status",tafweej.getStatus());
                child.setValue(crowdData);


                tafweej.setLat(String.valueOf(lat));
                tafweej.setLon(String.valueOf(lon));


            }






            @Override
            public void onStatusChanged(String s, int i, Bundle bundle) {

            }

            @Override
            public void onProviderEnabled(String s) {

                Logging.write("Provider is enabled");

            }

            @Override
            public void onProviderDisabled(String s) {
                buttonStop.setVisibility(View.INVISIBLE);
                buttonStart.setVisibility(View.VISIBLE);
                Logging.write("Provider is disable");
                Toast.makeText(getApplicationContext(), R.string.enable_gps_wifi,Toast.LENGTH_SHORT).show();


            }
        };

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            return;
        }
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);


    }


    public void buttonStop(View view) {
        locationManager.removeUpdates(locationListener);
        tafweej.setStatus("inActive");
        buttonStop.setVisibility(View.INVISIBLE);
        buttonStart.setVisibility(View.VISIBLE);
        crowdData.put("status",tafweej.getStatus());
        child.setValue(crowdData);
        seekBar.setEnabled(true);

    }

    public void buttonStart(View view) {


        if (ContextCompat.checkSelfPermission(getApplicationContext(),
                Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            // Permission is not granted
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this
                    , Manifest.permission.ACCESS_FINE_LOCATION)) {
                // Show an explanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.
            } else {
                // No explanation needed; request the permission
                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, MY_PERMISSIONS_REQUEST_LOCATION);

                // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
                // app-defined int constant. The callback method gets the
                // result of the request.
            }
        } else {

            getLocation();

        }

    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                getLocation();
            }
        }
    }


    @Override
    public void onBackPressed() {
        // do nothing.
    }

}




