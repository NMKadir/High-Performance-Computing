#include <stdio.h>
#include <cuda.h>
__global__ void findMax(int *maxVal, int *data, int N) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < N) {
        // Update maxVal with data[idx] if it's larger
        atomicMax(maxVal, data[idx]);// for maximum
        // atomicMin(maxVal, data[idx]);// for minum
    }
}

int main() {
    const int N = 8;
    int h_data[N] = {3, 17, 5, 20, 12, 8, 25, 10};
    int h_maxVal = 0; // Start with smallest possible value
    // int h_maxVal = 100; // Start with largest possible value
    int *d_data, *d_maxVal;
    cudaMalloc(&d_data, N * sizeof(int));
    cudaMalloc(&d_maxVal, sizeof(int));
    cudaMemcpy(d_data, h_data, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_maxVal, &h_maxVal, sizeof(int), cudaMemcpyHostToDevice);
    // Launch kernel
    findMax<<<1, N>>>(d_maxVal, d_data, N);
    cudaMemcpy(&h_maxVal, d_maxVal, sizeof(int), cudaMemcpyDeviceToHost);
    printf("Maximum value is: %d\n", h_maxVal);
    // printf("Minimum value is: %d\n", h_maxVal);
    return 0;
}