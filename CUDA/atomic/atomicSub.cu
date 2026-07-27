#include <stdio.h>
#include <cuda.h>
__global__ void testAtomicSub(int *x)
{
    atomicSub(x, 2); // subtract 2 from *x
}
int main() {
    int value = 10;
    int *d_value;
    cudaMalloc(&d_value, sizeof(int));
    cudaMemcpy(d_value, &value, sizeof(int), cudaMemcpyHostToDevice);
    testAtomicSub<<<1, 4>>>(d_value); // 4 threads subtract 2 each
    cudaMemcpy(&value, d_value, sizeof(int), cudaMemcpyDeviceToHost);
    printf("Final value: %d\n", value); // Should be 10 - (4*2) = 2
    return 0;
}