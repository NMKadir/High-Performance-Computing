//for multiple processes into each processes.
#include <stdio.h>
#include <mpi.h>
#define ELEMENTS_PER_PROC 3
int main(int argc, char *argv[]) {
    int rank, size;
    int send_data[12]; // 4 processes × 3
    // elements = 12
    int recv_data[ELEMENTS_PER_PROC];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    // Get process rank
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    // Get total number of processes
    // Initialize data only on root process
    if (rank == 0) {
        for (int i = 0; i < 12; i++) {
            send_data[i] = (i + 1) * 10; // Fill with 10, 20,..., 120
        }
    }
    // Scatter: send 3 integers to each process
    MPI_Scatter(send_data, ELEMENTS_PER_PROC, MPI_INT, recv_data, ELEMENTS_PER_PROC, MPI_INT, 0, MPI_COMM_WORLD);
    // Each process prints what it received
    printf("Process %d received:", rank);
    for (int i = 0; i < ELEMENTS_PER_PROC; i++) {
        printf(" %d", recv_data[i]);
    }
    printf("\n");
    MPI_Finalize(); // Finalize MPI
    return 0;
    }