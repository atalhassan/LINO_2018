package com.google.tafweej.tafweej;

public class Tafweej {

    private int crowd_id;
    private int campaign_id;
    private double lat;
    private double lon;
    private double crowd_contacts;


    public double getCrowd_contacts() {
        return crowd_contacts;
    }

    public void setCrowd_contacts(double crowd_contacts) {
        this.crowd_contacts = crowd_contacts;
    }


    public int getCrowd_id() {
        return crowd_id;
    }

    public void setCrowd_id(int crowd_id) {
        this.crowd_id = crowd_id;
    }

    public int getCampaign_id() {
        return campaign_id;
    }

    public void setCampaign_id(int campaign_id) {
        this.campaign_id = campaign_id;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }


}
