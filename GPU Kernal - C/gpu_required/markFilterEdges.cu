/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void markFilterEdges_gpu(int * src, int * dst, int * matches, int * keepEdges, int numEdges) {
	/** YOUR CODE GOES BELOW **/
	int numThreads = blockDim.x * gridDim.x; 
	int tid = blockDim.x * blockIdx.x + threadIdx.x;  
	int i;
	
	for(i = tid; i < numEdges; i += numThreads)
	{
	
	if(matches[src[tid]] == -1){
		if(matches[dst[tid]] == -1){
			
			keepEdges[tid] = 1;

		}else{
			keepEdges[tid] = 0;

		}
	}else{
		keepEdges[tid] = 0;
	} 


	}
	
	/** YOUR CODE GOES ABOVE **/
}
