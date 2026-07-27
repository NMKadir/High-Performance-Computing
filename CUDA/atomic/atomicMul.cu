#include <stdio.h>
#include <cuda.h>
__device__ unsigned long long atomicMul(unsigned long long *address, unsigned long long val) {
    unsigned long long old = *address, assumed;
    do {
        assumed = old;
        old = atomicCAS(address, assumed, assumed * val);
    }while(assumed != old);
    return old;
}
__global__ void factorialKernel(int n, unsigned long long *result) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x + 1; // Start from 1
    if (tid <= n) {
        atomicMul(result, (unsigned long long)tid);
    }
}

int main() {
    int n;
    printf("Enter a positive integer: ");
    scanf("%d", &n);
    unsigned long long h_result = 1;
    unsigned long long *d_result;
    cudaMalloc((void**)&d_result, sizeof(unsigned long long));
    cudaMemcpy(d_result, &h_result, sizeof(unsigned long long), cudaMemcpyHostToDevice);
    int threadsPerBlock = 256;
    int blocks = (n + threadsPerBlock - 1) / threadsPerBlock;
    factorialKernel<<<blocks, threadsPerBlock>>>(n, d_result);
    cudaMemcpy(&h_result, d_result, sizeof(unsigned long long), cudaMemcpyDeviceToHost);
    printf("Factorial of %d = %llu\n", n, h_result);
    return 0;
}