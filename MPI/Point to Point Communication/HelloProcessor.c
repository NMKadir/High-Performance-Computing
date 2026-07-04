#include<stdio.h>
#include<mpi.h>
int main(int argc, char *argv[]){
        int rank,size;
        //Must have lines
        MPI_Init(&argc, &argv);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        //Must have lines
        
        //code
        printf("Hello from processor %d of %d\n",rank,size);

        //Must have lines
        MPI_Finalize();
        return 0;
}