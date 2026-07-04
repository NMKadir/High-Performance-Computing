#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size;
    int data; // Variable to be broadcasted
    MPI_Init(&argc, &argv); // Initialize MPI
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Get process rank
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Get total number of processes
    if (rank == 0) {
    data = 100; // Root process sets the value
    printf("Process %d broadcasting data = %d\n", rank, data);
    }   
    // Broadcast data from root (rank 0) to all processes
    MPI_Bcast(&data, 1, MPI_INT, 0, MPI_COMM_WORLD);
    // Every process prints the received data
    printf("Process %d received data = %d\n", rank, data);
    MPI_Finalize(); // Finalize MPI
    return 0;
}