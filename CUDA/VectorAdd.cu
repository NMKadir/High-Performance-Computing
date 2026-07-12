#include<iostream>
#include<cuda.h>
#include<cmath>
#define N 1048576
__global__ void VecAdd(double *A, double *B, double *C){
        int idx = blockDim.x*blockIdx.x + threadIdx.x;
        if(idx<N){
                C[idx]=A[idx]+B[idx];
        }
}

int main(){
        size_t bytes = N*sizeof(double);

        //Allocating memory space in host
        double *A = (double*)malloc(bytes);
        double *B = (double*)malloc(bytes);
        double *C = (double*)malloc(bytes);


        //Allocating memory space in device
        double *A_d, *B_d,*C_d;
        cudaMalloc((void **)&A_d, bytes);
        cudaMalloc((void **)&B_d, bytes);
        cudaMalloc((void **)&C_d, bytes);

        //Initialization of vectors
        for(int i=0; i<N; i++){
                A[i]=1.0;
                B[i]=2.0;
        }
        //Copy from host to device memory
        cudaMemcpy(A_d, A, bytes, cudaMemcpyHostToDevice);
        cudaMemcpy(B_d, B, bytes, cudaMemcpyHostToDevice);

        //Set config parameters
            // thperblc = num of threads per block
            // blcpergrid = num of blocks per grid
        int thperblc = 256;
        int blcpergrid = ceil(float(N)/thperblc);
        //the kernel call
        VecAdd<<<blcpergrid,thperblc>>>(A_d, B_d, C_d);
        //copy data from device memory to host memory
        cudaMemcpy(C, C_d, bytes, cudaMemcpyDeviceToHost);
        double tolerance = 1.0e-14;
        for(int i=0; i<N; i++)
        {
                if( fabs(C[i] - 3.0) > tolerance)
                {
                        printf("\nError: value of C[%d] = %lf instead of 3.0\n\n", i, C[i]);
                        exit(1);
                }
        }
         //free host variables
        free(A);
        free(B);
        free(C);
        //free device variables 
        cudaFree(A_d);
        cudaFree(B_d);
        cudaFree(C_d);
        printf("\n---------------------------\n");
        printf("__SUCCESS__\n");
        printf("---------------------------\n");
        printf("N                 = %d\n", N);
        printf("Threads Per Block = %d\n", thperblc);
        printf("Blocks In Grid    = %d\n", blcpergrid);
        printf("---------------------------\n\n");

        return 0;
}
