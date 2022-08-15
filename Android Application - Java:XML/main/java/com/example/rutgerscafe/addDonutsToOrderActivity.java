package com.example.rutgerscafe;

import android.content.Intent;
import android.view.View;
import android.widget.*;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

public class addDonutsToOrderActivity extends AppCompatActivity {
    Spinner mySpinner;
    TextView myTextView;
    TextView subTotalTextView;
    ListView tempListViewOrder;
    String selectedItem;
    Button addToOrderButton;
    int donutQuantity;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Button addDonutToOrderButton = findViewById(R.id.addDonutToOrderButton);
        Intent in = getIntent();
        setContentView(R.layout.activity_add_donuts_to_order);

        // myTextView.setText(in.getStringExtra("flavorChoice"));
        Bundle bundle = in.getExtras();
        selectedItem = bundle.getString("selectedFlavor");
        super.onCreate(savedInstanceState);
        Integer[] donutQuantityOptions = {1,2,3,4,5};
        myTextView = findViewById(R.id.selectedDonutTextView);
        subTotalTextView = findViewById(R.id.subTotalDisplayTextView);
        addToOrderButton = findViewById(R.id.addDonutToOrderButton);
        // myTextView.setText("Hello");
        myTextView.setText(selectedItem);

        ArrayAdapter adapter = new ArrayAdapter<Integer>(this, android.R.layout.simple_list_item_1,donutQuantityOptions);
        mySpinner = findViewById(R.id.donutQuantitySpinner);
        tempListViewOrder = findViewById(R.id.yourOrderListView);

        mySpinner.setAdapter(adapter);
        mySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                donutQuantity = (int) mySpinner.getSelectedItem();
                subTotalTextView.setText("$"+ donutQuantity * 1.39);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        //TODO 1.39 is a Magic Number
        addToOrderButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Donut myDonut = new Donut(selectedItem,donutQuantity);
              //  toastMsg("You've successfully added a donut(s)!");
                System.out.println(myDonut.toString() + myDonut.hashCode());
                OrdersActivity.addToOrder(myDonut,1.39*donutQuantity,donutQuantity);
                Toast.makeText(getApplicationContext(), "You've succesfully added "+myDonut.toString()+" donut(s) to your order", Toast.LENGTH_SHORT).show();

                // OrdersActivity.getInstance().addToOrder(myDonut,1.39*donutQuantity,donutQuantity);

            }
        });


    /*
        mySpinner.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            }
        });
*/

       // addDonutToOrderButton.setOnClickListener((View.OnClickListener) this);
    }
    public void onClick(View view){
    }
    public void toastMsg(String msg) {
        Toast toast = Toast.makeText(this, msg, Toast.LENGTH_LONG);
        toast.show();
    }


}