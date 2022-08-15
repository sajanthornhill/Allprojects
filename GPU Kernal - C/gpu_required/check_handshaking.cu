/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Fall 2020                                 *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void check_handshaking_gpu(int * strongNeighbor, int * matches, int numNodes) {
	/** YOUR CODE GOES BELOW **/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	while( tid < numNodes )
	{
		if( tid == strongNeighbor[strongNeighbor[tid]] )
		{
			if( matches[tid] == -1 && matches[strongNeighbor[tid]] == -1 )
			{
				matches[tid] = strongNeighbor[tid];
				matches[strongNeighbor[tid]] = strongNeighbor[strongNeighbor[tid]];
			}
		}
		tid += ( blockDim.x * gridDim.x );
	}
	
	/** YOUR CODE GOES ABOVE **/
}
