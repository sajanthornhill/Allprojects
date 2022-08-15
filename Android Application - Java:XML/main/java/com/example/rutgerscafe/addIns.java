package com.example.rutgerscafe;

/**
 * defines the constants used as coffee add-ins
 * @author David Okechukwu, Sajan Thornhill
 */
public enum addIns {
    syrup("syrup", 0),
    cream("cream", 0),
    milk("milk", 0),
    caramel("caramel", 0),
    whippedcream("whippedcream", 0);

    private String name;
    private int count;

    addIns(String name, int count){
        this.name = name;
        this.count = count;

    }

    /**
     * returns a string representation of the constats
     * @return
     */
    @Override
    public String toString(){
        return " " + syrup.getName() + ":" + syrup.getCount() + " " +
                cream.getName() + ":" + cream.getCount() + " " + milk.getName() + ":"
                + milk.getCount() + " " + caramel.getName() + ":" + caramel.getCount() + " "
                + whippedcream.getName() + ":" + whippedcream.getCount();
    }

    /**
     * returns the count of a constant
     * @return
     */
    public int getCount(){
        return count;
    }

    /**
     * sets the count of a constat
     * @param num
     */
    public void setCount(int num){
        this.count = num;
    }

    /**
     * returns the name of a constant
     * @return
     */
    public String getName(){
        return name;
    }
}
