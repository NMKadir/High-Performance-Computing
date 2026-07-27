#include<iostream>
#include<cuda.h>

__global__ void add(int N, int *result){
    //Adding 1 to 100 
    int id = threadIdx.x+blockDim.x*blockIdx.x + 1;
    if(id<=N) atomicAdd(result, id);

}
int main(){
    int N = 100;
    int h_result = 0;
    int *d_result;

    cudaMalloc((void **)&d_result, sizeof(int));
    cudaMemcpy(d_result, &h_result, sizeof(int), cudaMemcpyHostToDevice);

    int threadsperblock = 32;
    int blocks = (N+threadsperblock-1)/threadsperblock;

    add<<<blocks, threadsperblock>>>(N, d_result);

    cudaMemcpy(&h_result, d_result, sizeof(int), cudaMemcpyDeviceToHost);

    std::cout << "sum of 1 to " << N << " = " << h_result << "\n";

    cudaFree(d_result);
    return 0;
}