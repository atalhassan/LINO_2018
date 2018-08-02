package com.google.tafweej.tafweej;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class VerificationActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verification);

        Button buttonVerification = (Button) findViewById(R.id.buttonVerify);
        final EditText editTextVerification = (EditText)  findViewById(R.id.editTextVerificationId);

        buttonVerification.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String verficationNumber = String.valueOf(editTextVerification.getText());

                if (verficationNumber.compareTo("000") == 0){

                    Toast.makeText(getApplicationContext(), R.string.loggedIn,Toast.LENGTH_SHORT);

                    Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                    startActivity(intent);
                }else{

                    Toast.makeText(getApplicationContext(), R.string.wrong_verification,Toast.LENGTH_SHORT).show();
                }


            }
        });
    }
}
