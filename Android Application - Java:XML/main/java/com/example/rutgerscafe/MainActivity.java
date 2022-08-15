package com.example.rutgerscafe;

import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    private Button button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        button = (Button) findViewById(R.id.donutButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openOrderDonuts();
            }
        });
        button = (Button) findViewById(R.id.coffeeButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("Method engaged Coffee");
                openOrderCoffee();
            }
        });
        button = (Button) findViewById(R.id.orderButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openOrders();
            }
        });
        button = (Button) findViewById(R.id.storeButton);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openStoreOrders();
            }
        });
    }

    public void openOrderCoffee(){
        Intent intent = new Intent(this, OrderCoffeeActivity.class);
        startActivity(intent);
    }

    public void openOrderDonuts(){
        Intent intent = new Intent(this, OrderDonutsActivity.class);

        startActivity(intent);
    }
    public void openOrders(){
        Intent intent = new Intent(this, OrdersActivity.class);
        startActivity(intent);
    }
    public void openStoreOrders(){
        Intent intent = new Intent(this, StoreOrdersActivity.class);
        startActivity(intent);
    }
}