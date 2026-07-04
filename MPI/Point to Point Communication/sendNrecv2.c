// Sending and receiving data from master processor (rank=0) to slave processors (rank=1,2,3)
// same variable name is used in all processors
#include<stdio.h>
#include<mpi.h>
int main(int argc, char *argv[]){
        int size, rank, num, sum=0;
        MPI_Init(&argc, &argv);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        if(rank==0){
                num=101;
                MPI_Send(&num, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
                num=102;
                MPI_Send(&num, 1, MPI_INT, 2, 0, MPI_COMM_WORLD);
                num=103;
                MPI_Send(&num, 1, MPI_INT, 3, 0, MPI_COMM_WORLD);
        }
        else if(rank==1){
                MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                printf("Processor %d out of %d has received %d\n",rank,size,num);
                //sum+=num;
        }

        else if(rank==2){
                MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                printf("Processor %d out of %d has received %d\n",rank,size,num);
                //sum+=num;
        }
        else if(rank==3){
                MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                printf("Processor %d out of %d has received %d\n",rank,size,num);
                //sum+=num;
        }
        //printf("Sum = %d\n", sum);
        MPI_Finalize();
        //printf("Sum = %d\n",sum);
        return 0;
}