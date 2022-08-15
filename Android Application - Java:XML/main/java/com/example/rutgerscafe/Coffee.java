package com.example.rutgerscafe;
/**
 * An instance of this class is a menu item in an order, extends MenuItem class and implements Customizable
 * @author David Okechukwu, Sajan Thornhill
 */
public class Coffee extends MenuItem implements Customizable{

    private double coffeeTotal = 0;
    private String size;
    private addIns[] coffeeAddIns = {addIns.caramel, addIns.cream, addIns.milk, addIns.syrup, addIns.whippedcream};
    private int numAddIns;

    private int coffeeQuantity;
    private int caramelQuantity;
    private int milkQuantity;
    private int creamQuantity;
    private int syrupQuantity;
    private int whippedCreamQuantity;

    public void setCaramelQuantity(int quantity){
        this.caramelQuantity = quantity;
    }
    public void setMilkQuantity(int quantity){
        this.milkQuantity = quantity;
    }
    public void setSyrupQuantity(int quantity){
        this.syrupQuantity = quantity;
    }
    public void setWhippedCreamQuantity(int quantity){
        this.whippedCreamQuantity = quantity;
    }
    public void setCreamQuantity(int quantity){
        this.creamQuantity = quantity;
    }
    /**
     * Resets the coffeeTotal to zero so that it can be recalculated
     */
    public void setTotalToZero(){
        coffeeTotal=0;

    }


    /**
     * @param size size to set instance's size to
     */
    public void setSize(String size){
        this.size=size;
    }

    /**
     * @param quantity quantity to set instance's quantity to
     */
    public void setQuantity(int quantity){
        this.coffeeQuantity= quantity;
    }

    /**
     * @return current quantity of the instance
     */
    public int getQuantity(){
        return coffeeQuantity;
    }

    /**
     * @return current size of the instance
     */
    public String getSize(){
        return size;
    }

    /**
     * Constructor for the Coffee class
     */
    public Coffee(){
        caramelQuantity = addIns.caramel.getCount();
        syrupQuantity = addIns.syrup.getCount();
        milkQuantity = addIns.milk.getCount();
        whippedCreamQuantity = addIns.whippedcream.getCount();
        creamQuantity = addIns.cream.getCount();

        numAddIns = coffeeAddIns.length;

    }

    /**
     * Calculates the item price for a coffee with or without add-ins
     * @return Coffee price
     */
    @Override
    public double itemPrice(){
        coffeeTotal = 0;
        switch(size){
            case "Short":
                coffeeTotal += Constants.basePrice;
                break;
            case "Tall":
                coffeeTotal += Constants.basePrice + Constants.tallPrice;
                break;
            case "Grande":
                coffeeTotal += Constants.basePrice + Constants.grandePrice;
                break;
            case "Venti":
                coffeeTotal += Constants.basePrice + Constants.ventePrice;
                break;

        }
        for(int i = 0; i < numAddIns; i++){
            coffeeTotal = coffeeTotal + (coffeeAddIns[i].getCount()*Constants.addIn);
        }
        return coffeeTotal;
    }

    /**
     * Adds a Coffee add-in
     * @param obj
     * @return
     */
    @Override
    public boolean add(Object obj) {
        String testString = (String) obj;

        for (int index = 0; index < coffeeAddIns.length; index++) {
            if(testString.equals(coffeeAddIns[index].getName())){
                coffeeAddIns[index].setCount(coffeeAddIns[index].getCount() + 1);
                return true;
            }
        }
        return false;
    }

    /**
     * Removes a Coffee add-in
     * @param obj
     * @return
     */
    @Override
    public boolean remove(Object obj) {
        String testString = (String) obj;
        for (int index = 0; index < coffeeAddIns.length; index++) {
            if(testString.equals(coffeeAddIns[index].getName())){
                if(coffeeAddIns[index].getCount() != 0) {
                    coffeeAddIns[index].setCount(coffeeAddIns[index].getCount() - 1);
                    return true;
                }
            }
        }
        return false;
    }


    /**
     *
     * @return an array of the Coffee's add-ins
     */
    public addIns[] getAddIns(){
        return coffeeAddIns;
    }

    public void setCaramelQuantity(){

    }
    public void setMilkQuantity(){

    }


    @Override
    public String toString(){
        return(this.getSize() + " :Coffee" + " " + "syrup" + ":" + syrupQuantity + " " +
                "cream" + ":" + creamQuantity+ " " + "milk" + ":"
                + milkQuantity + " " + "caramel" + ":" + caramelQuantity + " "
                + "whippedcream" + ":" + whippedCreamQuantity);
    }

}

/*



 */