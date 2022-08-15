package com.example.rutgerscafe;

/**
 * An instance of this class keeps the list of orders added by the user, implements Customizable interface
 * @author David Okechukwu, Sajan Thornhill
 */
public class StoreOrders implements Customizable {
    private static Order[] myOrders = new Order[4];
    private int numOrders;


    /**
     * Constructor for the class
     */
    public StoreOrders() {
        numOrders = 0;
    }


    /**
     * Finds an order in the order array
     * @param identifier
     * @return
     */
    public Order findOrder(int identifier) {

        for (int x = 0; x < myOrders.length; x++) {
            if (myOrders[x] != null) {
                if (myOrders[x].getOrderNumber() == identifier) {
                    return myOrders[x];
                }
            }
        }
        return null;
    }

    /**
     * Adds an order
     * @param obj
     * @return
     */
    @Override
    public boolean add(Object obj) {
        grow();
        if (obj == null) {
            return false;
        }
        if (numOrders == 0) {

            this.myOrders[0] = (Order) obj;
            numOrders++;
            return true;
        }
        for (int index = 0; index <= numOrders; index++) {

            if (this.myOrders[index] == null) {

                this.myOrders[index] = (Order) obj;

                numOrders++;
                grow();
                return true;
            }
        }
        return false;
    }

    /**
     * Removes an order
     * @param obj
     * @return true if the remove was successful, false otherwise
     */
    @Override
    public boolean remove(Object obj) {
        grow();
        Order[] tempOrders = new Order[myOrders.length - 1];
        int position = 0;
        for (int index = 0; index < numOrders; index++) {
            if (myOrders[index].equals(obj)) {
                myOrders[index] = null;
                position = index;

                break;
            }
        }

        if (position >= 0) {
            for (int x = position; x < myOrders.length && x != tempOrders.length - 1; x++) {
                myOrders[x] = myOrders[x + 1];
            }
            for (int x = 0; x < tempOrders.length; x++) {
                if (myOrders[x] != null) {
                    tempOrders[x] = myOrders[x];
                }



            }

            this.myOrders = tempOrders;

            numOrders--;

            return true;
        }
        return false;

    }

    /**
     * Grows the container array when full
     */

    private void grow() {
        if (numOrders % 4 == 0 && numOrders != 0) {
            Order[] tempOrders = new Order[myOrders.length + 4];
            for (int x = 0; x < myOrders.length; x++) {
                tempOrders[x] = myOrders[x];
            }
            myOrders = tempOrders;
        }
        if(numOrders % 1 == 1 && numOrders !=0){
            Order[] tempOrders = new Order[myOrders.length + 3];
            for (int x = 0; x < myOrders.length; x++) {
                tempOrders[x] = myOrders[x];
            }
            myOrders = tempOrders;
        }
    }

    /**
     * Goes through orders to export order details
     * @return
     */
    public String exportDatabase() {
        String exportString = "";
        for (int index = 0; index < numOrders; index++) {
            exportString += (this.getOrder()[index].printOrder() + "\n");
            for (int jindex = 0; jindex < this.getOrder()[index].menuItemsSize(); jindex++) {
                exportString += (this.getOrder()[index].getMenuItems(jindex).getMenuItemsDetails() + "\n");
            }
        }
        return exportString;
    }

    /**
     * Returns the order array
     * @return
     */
    public Order[] getOrder() {
        return myOrders;
    }
}
/*

 */