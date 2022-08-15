package com.example.rutgerscafe;
/**
 * Superclass of all menu items, such as donuts and coffee
 * @author David Okechukwu, Sajan Thornhill
 */
public class MenuItem {
    /**
     * Constructor for MenuItem
     */
    public MenuItem() {

    }

    /**
     * Calculates the price for a menuItem, should be overriden by subclasses
     * @return
     */
    public double itemPrice() {
        return 0;
    }

    /**
     * Getter method for menuItemDetails
     * @return string detailing a Coffee or Donut Instance
     */
    public String getMenuItemsDetails() {
        String allMenuItems = "";
        if (this instanceof Coffee) {
            allMenuItems += ((Coffee) this).toString();
        }
        if (this instanceof Donut) {
            allMenuItems += ((Donut) this).toString();
        }
        return allMenuItems;
    }

}