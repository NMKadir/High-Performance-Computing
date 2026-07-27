#include<iostream>
#include<cuda.h>
#define N 1024
__global__ void MatMul(double *A, double *B, double *C){
    int row = blockIdx.y*blockDim.y + threadIdx.y;
    int col = blockIdx.x*blockDim.x + threadIdx.x;
    if(row<N && col<N){
        double sum = 0.0;
        for(int k=0; k<N; k++){
            sum += A[row*N+k]*B[k*N+col];
        }
        C[row*N+col] = sum;
    }
}

int main(){
    size_t bytes = N*N*sizeof(double);
    double *A = (double*)malloc(bytes);
    double *B = (double*)malloc(bytes);
    double *C = (double*)malloc(bytes);
    for(int i=0; i<N; i++){
        for(int j=0; j<N; j++){
            A[i*N+j] = 1.0;
            B[i*N+j] = 3.0;
        }
    }
    double *A_d, *B_d, *C_d;
    cudaMalloc((void **)&A_d, bytes);
    cudaMalloc((void **)&B_d, bytes);
    cudaMalloc((void **)&C_d, bytes);
    cudaMemcpy(A_d, A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B, bytes, cudaMemcpyHostToDevice);
    dim3 thperblc(16, 16);
    dim3 blcpergrid(ceil(float(N)/thperblc.x), ceil(float(N)/thperblc.y));
    MatMul<<<blcpergrid, thperblc>>>(A_d, B_d, C_d);
    cudaMemcpy(C, C_d, bytes, cudaMemcpyDeviceToHost);
    double tolerance = 1.0e-14;
    for(int i=0; i<N; i++){
        for(int j=0; j<N; j++){
            if(fabs(C[i*N+j] - 3.0*N) > tolerance){
                printf("\nError: value of C[%d][%d] = %lf instead of %lf\n\n", i, j, C[i*N+j], 2.0*N);
                exit(1);
            }
        }
    }
    printf("Matrix multiplication completed successfully!\n");
    std::cout << "First 10 results for show:" << "\n";
    for(int i=0; i<1; i++){
        for(int j=0; j<10; j++){
            std::cout<<C[i*N+j]<< " ";
        }
        std::cout<<"\n";
    }
    free(A);
    free(B);
    free(C);

    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);
    return 0;
}