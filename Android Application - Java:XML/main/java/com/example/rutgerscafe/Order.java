package com.example.rutgerscafe;

import android.widget.ArrayAdapter;

import java.util.ArrayList;


/**
 * An instance of this class has a unique order number and keeps the list of menu items added by the user, implements Customizable interface
 * @author David Okechukwu, Sajan Thornhill
 */
public class Order implements Customizable {
    private int orderNumber;
    private MenuItem[] menuItems = new MenuItem[5];
    private int numOrderItems;
    private ArrayAdapter < String > orderContents;

    static int orderNumberCounter = 1000;
    private double orderTotal;

    /**
     * Constructor for Order class
     */
    public Order() {
        orderNumber = orderNumberCounter;
        orderNumberCounter++;

    }


    /**
     * Adds a Menu Item to menuItems
     * @param obj
     * @return
     */
    @Override
    public boolean add(Object obj) {
        grow();
        if (obj == null) {
            return false;
        }

        if (numOrderItems == 0) {
            this.menuItems[0] = (MenuItem) obj;
            numOrderItems++;
            return true;
        }
        for (int index = 0; index <= numOrderItems; index++) {

            if (this.menuItems[index] == null) {

                this.menuItems[index] = (MenuItem) obj;

                numOrderItems++;
                grow();
                return true;

            }
        }

        return false;
    }

    /**
     * Removes a Menu Item from MenuItems
     * @param obj
     * @return true if the remove was successful, false otherwise
     */
    @Override
    public boolean remove(Object obj) {
        grow();
        MenuItem[] tempOrders = new MenuItem[menuItems.length - 1];
        int position = 0;
        for (int index = 0; index < numOrderItems; index++) {
            if (menuItems[index].equals(obj)) {
                menuItems[index] = null;
                position = index;

                break;
            }
        }

        if (position >= 0) {
            for (int x = position; x < menuItems.length && x != tempOrders.length - 1; x++) {
                menuItems[x] = menuItems[x + 1];
            }
            for (int x = 0; x < tempOrders.length; x++) {
                if (menuItems[x] != null) {
                    tempOrders[x] = menuItems[x];
                }



            }

            this.menuItems = tempOrders;

            numOrderItems--;

            return true;
        }
        return false;

    }

    /**
     * Increases the size of menuItems when full
     */
    private void grow() {
        if (numOrderItems % 4 == 0 && numOrderItems != 0) {
            MenuItem[] tempMenuItems = new MenuItem[menuItems.length + 4];
            for (int x = 0; x < menuItems.length; x++) {
                tempMenuItems[x] = menuItems[x];
            }
            menuItems = tempMenuItems;
        }
        if (numOrderItems % 1 == 1 && numOrderItems != 0) {
            MenuItem[] tempMenuItems = new MenuItem[menuItems.length + 3];
            for (int x = 0; x < menuItems.length; x++) {
                tempMenuItems[x] = menuItems[x];
            }
            menuItems = tempMenuItems;
        }

    }

    /**
     * Getter method for orderNumber
     * @return orderNumber
     */
    public int getOrderNumber() {
        return orderNumber;
    }

    /**
     * Getter method for numOrders
     * @return numOrders number of Orders
     */
    public int getNumOrders() {
        return numOrderItems;
    }

    /**
     * Returns a particular menu Item in the array
     * @param i index of a particular menu Item in the array
     * @return MenuItem object
     */
    public MenuItem getMenuItems(int i) {
        return this.menuItems[i];
    }



    /**
     * Prints out the orders, order number in a particular format of "Order #: (order number)"
     * @return
     */

    public String printOrder() {
        return ("Order #: " + String.valueOf(this.getOrderNumber()));
    }

    /**
     * Sets the orderTotal for any order instance
     * @param totalForOrder
     */
    public void setOrderTotal(double totalForOrder) {
        this.orderTotal = totalForOrder;
    }

    /**
     * Returns the orderTotal of a order instance
     * @return
     */
    public double getOrderTotal() {
        return this.orderTotal;
    }
    /**
     * @return Returns the menuItems array for each order
     */
    public int menuItemsSize() {
        return numOrderItems;
    }

    public void printOrderList(){
        System.out.println("Printing the Backend....");
        for(MenuItem c : menuItems){
            System.out.println(c);
        }
    }
    public void setArrayAdapter( ArrayAdapter temp){
         this.orderContents = temp;
    }

    public ArrayAdapter getArrayAdapter(){
        return this.orderContents;
    }
    /**
     * Sets the observableList for any order instance
     * @param orderDetails
     */

   // public void setObservableList(ObservableList orderDetails) {
  //      this.orderContents = orderDetails;
  //  }

    /**
     * @return the observableList for any order instance
     */
   // public ObservableList getObservableList() {
  //      return this.orderContents;
  //  }

}