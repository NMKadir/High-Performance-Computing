#include <stdio.h>
#include <cuda.h>
#include <iostream>
#include <time.h>
__global__ void vectorAddShared(float *A, float *B, float *C, int N) {
    __shared__ float s_A[256];
    __shared__ float s_B[256];
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        s_A[threadIdx.x] = A[tid];
        s_B[threadIdx.x] = B[tid];
        __syncthreads(); // Wait for all threads to load data
        C[tid] = s_A[threadIdx.x] + s_B[threadIdx.x];
    }
}
int main(){
    int N = 1024; 
    size_t size = N*sizeof(float);
    float *h_A, *h_B, *h_C;
    float *d_A, *d_B, *d_C;
    h_A = (float*)malloc(size);
    h_B = (float*)malloc(size);
    h_C = (float*)malloc(size);

    for(int i = 0; i<N; i++){
        h_A[i] = i*1.0f;
        h_B[i] = i*2.0f;
    }
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    clock_t begin_time = clock();
    vectorAddShared<<<N/256, 256>>>(d_A, d_B, d_C, N);
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    for (int i = 0; i < 10; i++)    printf("%f + %f = %f\n", h_A[i], h_B[i], h_C[i]);
    clock_t end_time = clock();
    std::cout<<"Spent Time = " <<float(end_time-begin_time)/CLOCKS_PER_SEC << "\n";
    return 0;
}