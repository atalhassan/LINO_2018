package com.google.tafweej.tafweej;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class LoginActivity extends AppCompatActivity {


    Tafweej tafweej;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        Button buttonSignUp = (Button)findViewById(R.id.buttonSignUp);
        final EditText editTextCampaignId = (EditText) findViewById(R.id.editTextCampaignID);
        final EditText editTextContactNumber = (EditText) findViewById(R.id.editTextPhoneNumber);


        buttonSignUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String campaignID = String.valueOf(editTextCampaignId.getText());
                String contactNumbner = String.valueOf(editTextContactNumber.getText());

                tafweej = new Tafweej();

                if (campaignID.compareTo("") != 0  && contactNumbner.compareTo("")!=0){

                    tafweej.setCampaign_id(Integer.parseInt(campaignID));
                    tafweej.setCrowd_contacts(Integer.parseInt(contactNumbner));

                    if(tafweej.getCampaign_id() == 000 && tafweej.getCrowd_contacts() == 000){
                        tafweej.setCrowd_id(Integer.parseInt(Helper.generateUnique(4)));

                        Intent intent = new Intent(getApplicationContext(), VerificationActivity.class);
                        startActivity(intent);
                    }


                }else {
                    Logging.write("wrong data");
                    Toast.makeText(getApplicationContext(), R.string.wrong_credentials,Toast.LENGTH_LONG).show();

                }

            }
        });
    }
}
