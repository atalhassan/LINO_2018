package com.google.tafweej.tafweej;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.RequiresApi;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.ValueEventListener;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.Query;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class LoginActivity extends AppCompatActivity {

    LocationUpdaterService locationUpdaterService;
    Tafweej tafweej;
    HashMap<String,Object> compaignValues = null;

    private String[] permissions = {Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission
            .ACCESS_FINE_LOCATION, Manifest.permission.INTERNET};

    EditText editTextCampaignId;
    EditText editTextContactNumber;

    Firebase mRef;

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        Button buttonSignUp = (Button) findViewById(R.id.buttonSignUp);




        editTextCampaignId = (EditText) findViewById(R.id.editTextCampaignID);
        editTextContactNumber = (EditText) findViewById(R.id.editTextPhoneNumber);

        //locationUpdaterService = new LocationUpdaterService();
        //locationUpdaterService.onCreate();




        tafweej = Tafweej.getInstance();


        if(arePermissionsEnabled()){

            Logging.write("permission granted");
        }else{
            requestMultiplePermissions();
        }




        buttonSignUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                signUp();


            }
        });
    }




    private void signUp(){

        String campaign_id = editTextCampaignId.getText().toString();
        String contacts = editTextContactNumber.getText().toString();

        mRef = new Firebase("https://lino2018-ad380.firebaseio.com/Campaign");
        mRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                HashMap<Object, Object> campaignNames = dataSnapshot.getValue(HashMap.class);


                Logging.write("cam -> " + campaignNames);
                HashMap<Object, Object> campaign_details = (HashMap<Object, Object>) campaignNames.get(campaign_id);


                if (campaignNames.containsKey(campaign_id) && ((String) campaign_details.get("phone")).compareTo(contacts) == 0) {

                    tafweej.setCampaign_id(campaign_id);
                    tafweej.setCampaign_contacts(contacts);
                    Intent intent = new Intent(getApplicationContext(),VerificationActivity.class);
                    startActivity(intent);
                }else{

                    Toast.makeText(getApplicationContext(),R.string.error_sign_up, Toast.LENGTH_SHORT).show();
                }
            }


            @Override
            public void onCancelled(FirebaseError firebaseError) {

            }
        });






    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private boolean arePermissionsEnabled(){
        for(String permission : permissions){
            if(checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED)
                return false;
        }
        return true;
    }



    @RequiresApi(api = Build.VERSION_CODES.M)
    private void requestMultiplePermissions(){
        List<String> remainingPermissions = new ArrayList<>();
        for (String permission : permissions) {
            if (checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) {
                remainingPermissions.add(permission);
            }
        }
        requestPermissions(remainingPermissions.toArray(new String[remainingPermissions.size()]), 101);
    }


    @RequiresApi(api = Build.VERSION_CODES.M)
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(requestCode == 101){
            for(int i=0;i<grantResults.length;i++){
                if(grantResults[i] != PackageManager.PERMISSION_GRANTED){
                    if(shouldShowRequestPermissionRationale(permissions[i])){
                        new AlertDialog.Builder(this)
                                .setMessage(R.string.error_perms)
                                .setPositiveButton("Allow", (dialog, which) -> requestMultiplePermissions())
                                .setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss())
                                .create()
                                .show();
                    }
                    return;
                }
            }
            //all is good, continue flow
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
    }


}
