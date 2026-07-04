// From master processor (rank=0) to slave processor (rank=1)
#include<stdio.h>
#include<mpi.h>
int main(int argc, char *argv[]){
        int num, rank,size;
        MPI_Init(&argc, &argv);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Comm_size(MPI_COMM_WORLD, &size);

        if(rank==0){
                num=42;
                MPI_Send(&num, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        }
        else if(rank==1){
                MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                printf("Processor %d of %d received %d\n",rank,size,num);
        }

        MPI_Finalize();
        return 0;
}