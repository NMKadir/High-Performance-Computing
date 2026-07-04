#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size;
    int data[4]; // Array to be scattered (only used on root)
    int recv_value; // Each process will receive one element
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (size != 4) {
        if (rank == 0) {
            printf("Please run with 4 processes for this example.\n");
        }
        return 0;
    }
    // Initialize data on root process
    if (rank == 0) {
        for (int i = 0; i < 4; i++) {
            data[i] = (i + 1) * 10; // 10, 20, ..., 40
        }
    }
    // Scatter the data
    MPI_Scatter(data, 1, MPI_INT, &recv_value, 1, MPI_INT, 0, MPI_COMM_WORLD);
    printf("Process %d received value %d\n", rank, recv_value);
    MPI_Finalize();
    return 0;
}