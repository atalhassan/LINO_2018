package com.google.tafweej.tafweej;

import java.util.Random;
import java.util.UUID;

public class Helper {


    public static String generateUnique(int size){

        Random rand = new Random();
        String randomNumber = "";
        for(int i = 0 ; i  < size; i ++) {
            int n = rand.nextInt(9);
            randomNumber = randomNumber + n;
        }
        Logging.write("Size of id -> "+randomNumber);
        return randomNumber;
    }


    public static String generateRandomChar(){


        Random r = new Random();
        char c = (char)(r.nextInt(26) + 'A');
        return String.valueOf(c);
    }
}
