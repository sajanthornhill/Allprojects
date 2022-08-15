#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>




void NOT(int *values, int inputI, int outputI) {
    values[outputI] = !values[inputI];
}

void AND(int *values, int inputI1, int inputI2, int outputI) {
    values[outputI] = values[inputI1] && values[inputI2];
}

void OR(int *values, int inputI1, int inputI2, int outputI) {
    values[outputI] = values[inputI1] || values[inputI2];
}

void NAND(int *values, int inputI1, int inputI2, int outputI) {
    values[outputI] = !(values[inputI1] && values[inputI2]);
}

void NOR(int *values, int inputI1, int inputI2, int outputI) {
    values[outputI] = !(values[inputI1] || values[inputI2]);
}

void XOR(int *values, int inputI1, int inputI2, int outputI) {
    values[outputI] = values[inputI1] ^ values[inputI2];
}

void PASS(int *values, int inputI, int outputI) {
    values[outputI] = values[inputI];
}

void DECODER(int *values, int n, int *inputI, int *outputI) {
    int s = 0;
    int i;
    for (i = 0; i < pow(2, n); i++) {
        values[outputI[i]] = 0;
    }
    for (i = 0; i < n; i++) {
        s += values[inputI[i]] * pow(2, n - i - 1);
    }
    values[outputI[s]] = 1;
}

void MUX(int *values, int n, int *inputI, int *selectorI, int outputI) {
    int s = 0;
    int i;
    for (i = 0; i < n; i++) {
        s += values[selectorI[i]] * pow(2, n - i - 1);
    }
    values[outputI] = values[inputI[s]];
}


int searchIndex(int size, char **array, char *var) {
    int i;
    for (i = 0; i < size; i++) {
        if (strcmp(array[i], var) == 0) {
            return i;
        }
    }
    return -1;
}

void resetArray(int size, int *array) {
    int i;
    for (i = 0; i < size; i++) {
        array[i] = 0;
    }
    array[1] = 1;
}


struct instructions {
    char gate[17];
    int decN;
    int muxS;
    int *inputs;
    int *outputs;
    int *selectors;
};

int inOrder(int *array, int inputCount) {
    int i;
    for (i = inputCount + 1; i >= 2; i--) {
        array[i] = !array[i];
        if (array[i] == 1) {
            return 1;
        }
    }
    return 0;
}
int main(int argc, char** argv) {


    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Invalid input\n");
        return 0;
    }



    int stepCount = 0;
    int size = 2;
    int inputCount = 0;
    int outputCount = 0;
    int tempCount = 0;
    char instruct[17];
    char **info;
    int *valueArray = malloc(size * sizeof(int));
    struct instructions* circuitStep = NULL;



    fscanf(file, " %s", instruct);
    fscanf(file, "%d", &inputCount);


    size += inputCount;
    info = malloc(size * sizeof(char *));
    info[0] = malloc(2 * sizeof(char));
    info[0] = "0\0";
    info[1] = malloc(2 * sizeof(char));
    info[1] = "1\0";



    int i;
    for (i = 0; i < inputCount; i++) {
        info[i + 2] = malloc(17 * sizeof(char));
        fscanf(file, "%*[: ]%16s", info[i + 2]);
    }



    fscanf(file, " %s", instruct);
    fscanf(file, "%d", &outputCount);
    size += outputCount;
    info = realloc(info, size * sizeof(char *));
    for (i = 0; i < outputCount; i++) {
        info[i + inputCount + 2] = malloc(17 * sizeof(char));
        fscanf(file, "%*[: ]%16s", info[i + inputCount + 2]);
    }


//----------------------------------------------------------------------

    while (!feof(file)) {
        int numInputs = 2, numOutputs = 1;
        struct instructions circuit;
        int sc = fscanf(file, " %s", instruct); 
        if (sc != 1) {
            break;
        }
        
        stepCount++;
        circuit.muxS = 0;
        circuit.decN = 0;
        
        strcpy(circuit.gate, instruct);

        if (strcmp(instruct, "NOT") == 0) {
            numInputs = 1;
        }
        if (strcmp(instruct, "PASS") == 0) {
            numInputs = 1;
        }
        if (strcmp(instruct, "DECODER") == 0) {
            fscanf(file, "%d", &numInputs);
            circuit.decN = numInputs;
            numOutputs = pow(2, numInputs);
        }
        if (strcmp(instruct, "MULTIPLEXER") == 0) {
            fscanf(file, "%d", &numInputs);
            circuit.muxS = numInputs;
            numInputs = pow(2, numInputs);
        }

        circuit.inputs = malloc(numInputs * sizeof(int));
        circuit.outputs = malloc(numOutputs * sizeof(int));
        circuit.selectors = malloc(circuit.muxS * sizeof(int));

        char v[17];
        for (i = 0; i < numInputs; i++) {
            fscanf(file, "%*[: ]%16s", v);
            circuit.inputs[i] = searchIndex(size, info, v);
        }

        for (i = 0; i < circuit.muxS; i++) {
            fscanf(file, "%*[: ]%16s", v);
            circuit.selectors[i] = searchIndex(size, info, v);
        }
 
        for (i = 0; i < numOutputs; i++) {
            fscanf(file, "%*[: ]%16s", v);
            int idx = searchIndex(size, info, v);
            if (idx == -1) {
                size++;
                tempCount++;
                info = realloc(info, size * sizeof(char *));
                info[size - 1] = malloc(17 * sizeof(char));
                strcpy(info[size - 1], v);
                circuit.outputs[i] = size - 1;
            }
            else {
                circuit.outputs[i] = idx;
            }
        }
        if (!circuitStep) {
            circuitStep = malloc(sizeof(struct instructions));
        } else {
            circuitStep = realloc(circuitStep, stepCount * sizeof(struct instructions));
        }
        circuitStep[stepCount - 1] = circuit;
    }

//-------------------------------------------------------------------------


    valueArray = malloc(size * sizeof(int));
    resetArray(size, valueArray);
    
    
    
    

    while(1 < 2) {
        for (i = 0; i < inputCount; i++) {
            printf("%d ", valueArray[i + 2]);
        }
        printf("|");
        for (i = 0; i < stepCount; i++) {
            struct instructions circuit = circuitStep[i];
            if (strcmp(circuit.gate, "NOT") == 0) {
                NOT(valueArray, circuit.inputs[0], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "AND") == 0) {
                AND(valueArray, circuit.inputs[0], circuit.inputs[1], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "OR") == 0) {
                OR(valueArray, circuit.inputs[0], circuit.inputs[1], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "NAND") == 0) {
                NAND(valueArray, circuit.inputs[0], circuit.inputs[1], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "NOR") == 0) {
                NOR(valueArray, circuit.inputs[0], circuit.inputs[1], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "XOR") == 0) {
                XOR(valueArray, circuit.inputs[0], circuit.inputs[1], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "PASS") == 0) {
                PASS(valueArray, circuit.inputs[0], circuit.outputs[0]);
            }
            if (strcmp(circuit.gate, "DECODER") == 0) {
                DECODER(valueArray, circuit.decN, circuit.inputs, circuit.outputs);
            }
            if (strcmp(circuit.gate, "MULTIPLEXER") == 0) {
                MUX(valueArray, circuit.muxS, circuit.inputs, circuit.selectors, circuit.outputs[0]);
            }
        }





        for (i = 0; i < outputCount; i++) {
            printf(" %d", valueArray[inputCount + i + 2]);
        }
        printf("\n");

        if (!inOrder(valueArray, inputCount)) {
            break;
        }
    }

    return 0;
}

