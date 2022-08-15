package com.example.rutgerscafe;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.text.NumberFormat;
import java.util.Locale;

public class OrderCoffeeActivity extends AppCompatActivity implements AdapterView.OnItemSelectedListener {
    private Spinner spinner_Size;
    private Spinner spinner_Quantity;
    private Spinner spinner_SyrupQuantity;
    private Spinner spinner_CreamQuantity;
    private Spinner spinner_WhippedCreamQuantity;
    private Spinner spinner_CaramelQuantity;
    private Spinner spinner_MilkQuantity;

    private Button submit_Button;

    private TextView totalTextView;
    private NumberFormat n = NumberFormat.getCurrencyInstance(Locale.US);

    Coffee myCoffee = new Coffee();

    private double CoffeeTotal;

    private String coffeeSize;
    private String Quantity;
    private String creamQuantity;
    private String whippedcreamQuantity;
    private String caramelQuantity;
    private String milkQuantity;
    private String syrupQuantity;

    addIns milk = addIns.milk;
    addIns whippedcream = addIns.whippedcream;
    addIns syrup = addIns.syrup;
    addIns cream = addIns.cream;
    addIns caramel = addIns.caramel;

    ListView addInsList;
    String[] addInsArray = {"Syrup", "Cream", "Whipped Cream", "Caramel", "Milk" };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_coffee);

        addInsList = findViewById(R.id.AddInsListView);
        ArrayAdapter<String> addInAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, addInsArray);
        addInsList.setAdapter(addInAdapter);

        totalTextView = findViewById(R.id.totalTextView);


        setTitle("Order Coffee");
        spinner_Size = findViewById(R.id.spinnerSize);
        ArrayAdapter<CharSequence> adapterSize = ArrayAdapter.createFromResource(this,R.array.Sizes, android.R.layout.simple_spinner_item);
        adapterSize.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_Size.setAdapter(adapterSize);

        spinner_Quantity = findViewById(R.id.spinnerQuantity);
        ArrayAdapter<CharSequence> adapterQuantity = ArrayAdapter.createFromResource(this, R.array.Quantity, android.R.layout.simple_spinner_item);
        adapterQuantity.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_Quantity.setAdapter(adapterQuantity);

        spinner_SyrupQuantity = findViewById(R.id.spinnerSyrupQuantity);
        ArrayAdapter<CharSequence> adapterSyrup = ArrayAdapter.createFromResource(this, R.array.addInsQuantity, android.R.layout.simple_spinner_item);
        adapterSyrup.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_SyrupQuantity.setAdapter(adapterSyrup);

        spinner_CreamQuantity = findViewById(R.id.spinnerCreamQuantity);
        ArrayAdapter<CharSequence> adapterCream = ArrayAdapter.createFromResource(this, R.array.addInsQuantity, android.R.layout.simple_spinner_item);
        adapterSyrup.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_CreamQuantity.setAdapter(adapterCream);

        spinner_WhippedCreamQuantity = findViewById(R.id.spinnerWCQuantity);
        ArrayAdapter<CharSequence> adapterWhippedCream = ArrayAdapter.createFromResource(this, R.array.addInsQuantity, android.R.layout.simple_spinner_item);
        adapterSyrup.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_WhippedCreamQuantity.setAdapter(adapterWhippedCream);

        spinner_CaramelQuantity = findViewById(R.id.spinnerCaramelQuantity);
        ArrayAdapter<CharSequence> adapterCaramel = ArrayAdapter.createFromResource(this, R.array.addInsQuantity, android.R.layout.simple_spinner_item);
        adapterSyrup.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_CaramelQuantity.setAdapter(adapterCaramel);

        spinner_MilkQuantity = findViewById(R.id.spinnerMilkQuantity);
        ArrayAdapter<CharSequence> adapterMilk = ArrayAdapter.createFromResource(this, R.array.addInsQuantity, android.R.layout.simple_spinner_item);
        adapterSyrup.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_MilkQuantity.setAdapter(adapterMilk);

        spinner_SyrupQuantity.setOnItemSelectedListener(this);
        spinner_CreamQuantity.setOnItemSelectedListener(this);
        spinner_WhippedCreamQuantity.setOnItemSelectedListener(this);
        spinner_CaramelQuantity.setOnItemSelectedListener(this);
        spinner_MilkQuantity.setOnItemSelectedListener(this);
        spinner_Quantity.setOnItemSelectedListener(this);
        spinner_Size.setOnItemSelectedListener(this);

        coffeeSize = spinner_Size.getSelectedItem().toString();
        Quantity = spinner_Quantity.getSelectedItem().toString();
        syrupQuantity = spinner_SyrupQuantity.getSelectedItem().toString();
        creamQuantity = spinner_CreamQuantity.getSelectedItem().toString();
        whippedcreamQuantity = spinner_WhippedCreamQuantity.getSelectedItem().toString();
        caramelQuantity = spinner_CaramelQuantity.getSelectedItem().toString();
        milkQuantity = spinner_MilkQuantity.getSelectedItem().toString();

        submit_Button = findViewById(R.id.submitCoffeeButton);
        submit_Button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                calculateTotal();
                if(coffeeSize.equals("No size") || Quantity.equals("0")){
                    Toast.makeText(getApplicationContext(), "Please choose a size and quantity", Toast.LENGTH_LONG).show();
                }
                else{
                    OrdersActivity.addToOrder(myCoffee, CoffeeTotal, myCoffee.getQuantity());
                }
            }
        });

    }

    public void calculateTotal(){
        int quantityInt = Integer.parseInt(Quantity);
        int syrupQuantityInt = Integer.parseInt(syrupQuantity);
        int creamQuantityInt = Integer.parseInt(creamQuantity);
        int whippedcreamQuantityInt = Integer.parseInt(whippedcreamQuantity);
        int caramelQuantityInt = Integer.parseInt(caramelQuantity);
        int milkQuantityInt = Integer.parseInt(milkQuantity);

        syrup.setCount(syrupQuantityInt);
        cream.setCount(creamQuantityInt);
        whippedcream.setCount(whippedcreamQuantityInt);
        caramel.setCount(caramelQuantityInt);
        milk.setCount(milkQuantityInt);

        myCoffee.setCaramelQuantity(caramelQuantityInt);
        myCoffee.setCreamQuantity(creamQuantityInt);
        myCoffee.setMilkQuantity(milkQuantityInt);
        myCoffee.setSyrupQuantity(syrupQuantityInt);
        myCoffee.setWhippedCreamQuantity(whippedcreamQuantityInt);


        myCoffee.setSize(coffeeSize);
        myCoffee.setQuantity(quantityInt);


        double totalSum = myCoffee.itemPrice();
        CoffeeTotal = totalSum;
        totalTextView.setText(n.format(totalSum));


    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        if(position >= 1) {
            switch (parent.getId()) {
                case R.id.spinnerSize:
                    coffeeSize = spinner_Size.getSelectedItem().toString();
                    calculateTotal();
                    break;
                case R.id.spinnerQuantity:
                    Quantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                case R.id.spinnerSyrupQuantity:
                    syrupQuantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                case R.id.spinnerCreamQuantity:
                    creamQuantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                case R.id.spinnerWCQuantity:
                    whippedcreamQuantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                case R.id.spinnerCaramelQuantity:
                    caramelQuantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                case R.id.spinnerMilkQuantity:
                    milkQuantity = parent.getItemAtPosition(position).toString();
                    calculateTotal();
                    break;
                default:
                    break;
            }
        }

    }



    @Override
    public void onNothingSelected(AdapterView<?> parent) {

    }

    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {

    }


}