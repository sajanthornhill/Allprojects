package com.example.rutgerscafe;

import android.view.View;
import android.widget.*;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

import java.lang.reflect.Array;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Locale;

public class StoreOrdersActivity extends AppCompatActivity {
    Spinner mySpinner;
    private TextView totalTextViewArea;
    static StoreOrders myStoreOrder = new StoreOrders();
    private NumberFormat n = NumberFormat.getCurrencyInstance(Locale.US);
    private static ArrayList<Integer> orderNumberList = new ArrayList<Integer>();
    private ListView orderContentsListView;
    Button cancelOrderButton;
    private ArrayAdapter<Integer> orderNumberListAdapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        orderNumberListAdapter = new ArrayAdapter<Integer>(this,android.R.layout.simple_list_item_1);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_orders);
        mySpinner = findViewById(R.id.orderListSpinner);
        totalTextViewArea = findViewById(R.id.selectedOrderTotal);
        cancelOrderButton = findViewById(R.id.cancelOrderButton);
        orderContentsListView = findViewById(R.id.orderContentsListView);
        orderNumberListAdapter.addAll(orderNumberList);
        mySpinner.setAdapter(orderNumberListAdapter);
        //TODO testing on this... fix
        cancelOrderButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (myStoreOrder.getOrder()[0] == null == true || mySpinner.getSelectedItem() == null) {
                    return;
                }
                else{
                   // orderNumberListAdapter = new ArrayAdapter<Integer>(this,android.R.layout.simple_list_item_1);
                    Integer orderToRemove = orderNumberList.indexOf(myStoreOrder.findOrder((Integer) mySpinner.getSelectedItem()).getOrderNumber());
                    System.out.println("Order to remove is "+ orderToRemove);
                    myStoreOrder.remove(myStoreOrder.findOrder((Integer)mySpinner.getSelectedItem()));
                    for(int c : orderNumberList){
                        System.out.println("Before "+ c);
                    }

                    orderNumberList.remove(0);
                    for(int c : orderNumberList){
                        System.out.println("After "+ c);
                    }
                    orderNumberList.remove(orderToRemove);
                    orderNumberListAdapter.remove(orderToRemove);
                    // orderNumberListAdapter.clear();
                    // orderNumberListAdapter.addAll(orderNumberList);
                    orderNumberListAdapter.notifyDataSetChanged();
                    //mySpinner.setAdapter(myAdapter);
                    orderContentsListView.setAdapter(null);
                    totalTextViewArea.setText(n.format(0));
                    mySpinner.setAdapter(orderNumberListAdapter);

                }


            }
        });
        mySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                try{
                    Order tempObject = myStoreOrder.findOrder((Integer)mySpinner.getSelectedItem());
                    tempObject.printOrderList();
                    totalTextViewArea.setText(n.format(tempObject.getOrderTotal()));
                    fillArrayAdapter(tempObject);
                    orderContentsListView.setAdapter(tempObject.getArrayAdapter());
                }
                catch(Exception e){

                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

    }
    public static void addToStoreOrder(Order myOrder, double orderTotal, int orderNumber,ArrayAdapter<String> orderContent) {

        myOrder.setArrayAdapter(orderContent);
        myStoreOrder.add(myOrder);
        orderNumberList.add(orderNumber);
    //    totalTextArea.setText(n.format(orderTotal));
    }
    public void fillArrayAdapter(Order tempOrder) {
        ArrayAdapter<String> getOrderNumberList = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1);
        for (int x = 0; x < tempOrder.getNumOrders(); x++) {
            getOrderNumberList.add(tempOrder.getMenuItems(x).toString());
        }
        tempOrder.setArrayAdapter(getOrderNumberList);

    }

}