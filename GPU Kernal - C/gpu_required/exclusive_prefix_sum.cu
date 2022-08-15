/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void exclusive_prefix_sum_gpu(int * oldSum, int * newSum, int distance, int numElements) {
	/** YOUR CODE GOES BELOW **/
int numThreads = blockDim.x * gridDim.x; 
	int tid = blockDim.x * blockIdx.x + threadIdx.x;  
	int i;

	for(i = tid; i <= numElements; i += numThreads)
	{
		if(distance == 0 ){
			if(tid == 0){
				newSum[tid] = 0;	
			}
			else{
				
				newSum[tid] = oldSum[tid-1];
			}
		}
		else{ 
			if(tid - distance >= 0){ 
				newSum[tid] = oldSum[tid] + oldSum[tid-distance]; 
			

			}else{ 
				newSum[tid] = oldSum[tid];	
				
			}
		}

	}
	/** YOUR CODE GOES ABOVE **/
}
