package com.google.tafweej.tafweej;

public class Tafweej {

    private String crowd_id;
    private String campaign_id;
    private String lat;
    private String lon;
    private String campaign_contacts;



    private String Status;



    private static Tafweej INSTANCE = null;
    // other instance variables can be here
    private Tafweej() {};

    public static Tafweej getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new Tafweej();
        }
        return(INSTANCE);
    }

    public String getCampaign_contacts() {
        return campaign_contacts;
    }

    public void setCampaign_contacts(String campaign_contacts) {
        this.campaign_contacts = campaign_contacts;

    }


    public String getCrowd_id() {
        return crowd_id;
    }

    public void setCrowd_id(String crowd_id) {
        this.crowd_id = crowd_id;
    }

    public String getCampaign_id() {
        return campaign_id;
    }

    public void setCampaign_id(String campaign_id) {
        this.campaign_id = campaign_id;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLon() {
        return lon;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String status) {
        Status = status;
    }

}
