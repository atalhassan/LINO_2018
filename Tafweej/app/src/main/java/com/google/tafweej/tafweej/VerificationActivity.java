package com.google.tafweej.tafweej;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.firebase.client.Firebase;

import java.util.HashMap;

public class VerificationActivity extends AppCompatActivity {

    Firebase mRef;
    Tafweej tafweej;


    HashMap<Object,Object> crowdData;
    HashMap<Object,Object> location;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verification);

        location = new HashMap<>();
        location.put("lat",0);
        location.put("lng",0);
        Button buttonVerification = (Button) findViewById(R.id.buttonVerify);
        final EditText editTextVerification = (EditText)  findViewById(R.id.editTextVerificationId);

        tafweej = Tafweej.getInstance();

        buttonVerification.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String verficationNumber = String.valueOf(editTextVerification.getText());

                if (verficationNumber.compareTo("000") == 0){

                    Toast.makeText(getApplicationContext(), R.string.loggedIn,Toast.LENGTH_SHORT);
                    mRef = new Firebase("https://lino2018-ad380.firebaseio.com/");
                    tafweej.setCrowd_id(Helper.generateRandomChar()+Helper.generateUnique(2));
                    String crowd_id = tafweej.getCrowd_id();
                    Logging.write("crowd_id == "+ crowd_id);
                    Firebase  child = mRef.child("Crowd").child(crowd_id);
                    //tafweej.setCrowd_id(Helper.generateRandomChar()+Helper.generateUnique(2));

                    tafweej.setStatus("InActive");
                    crowdData = new HashMap<>();
                    crowdData.put("campaign_id", tafweej.getCampaign_id());
                    crowdData.put("location",location);
                    crowdData.put("numberOfPeople", 0);
                    crowdData.put("status",tafweej.getStatus());
                    Logging.write("crowd_id == "+ crowd_id);
                    child.setValue(crowdData);

                    Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                    startActivity(intent);
                }else{

                    Toast.makeText(getApplicationContext(), R.string.wrong_verification,Toast.LENGTH_SHORT).show();
                }


            }
        });
    }

    @Override
    public void onBackPressed() {
        // do nothing.
    }
}
