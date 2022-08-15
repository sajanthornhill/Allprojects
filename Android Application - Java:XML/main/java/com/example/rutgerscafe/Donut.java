package com.example.rutgerscafe;

public class Donut extends MenuItem {
    private String flavor;
    private double donutPrice;
    private int Quantity;

    /* Constructor for Donut
     * @param flavor
     * @param Quantity
     */
    public Donut(String flavor, int Quantity){
        this.flavor = flavor;
        this.Quantity = Quantity;
        this.donutPrice = Constants.DONUT_PRICE;

    }

    /*
     * @return donutPrice
     */
    @Override
    public double itemPrice(){
        return donutPrice;
    }

    /*
     * @return Quantity
     */
    public int getQuantity(){return Quantity;}

    /*
     * @return flavor
     */
    public String getFlavor(){
        return flavor;
    }


//TODO this method is redundant somewhere... returnDonut does the same thing
    /* returns a string od donut type and flavor
     * @return
     */
    @Override
    public String toString(){
        return Quantity +" "+ flavor;
    }

}