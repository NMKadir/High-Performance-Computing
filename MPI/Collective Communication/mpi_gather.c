#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size;
    int send_value; // Value to send from each process
    int gathered_values[4]; // Buffer to gather values on
    // root
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (size != 4) {
        if (rank == 0) {
            printf("Please run with 4 processes for this example.\n");
        }
        return 0;
    }
    send_value = (rank + 1) * 100; // Each process sends a unique value
    // Gather values from all processes into
    // gathered_values on rank 0
    MPI_Gather(&send_value, 1, MPI_INT, gathered_values, 1, MPI_INT, 0, MPI_COMM_WORLD);
    // Only the root process prints the gathered array
    if (rank == 0) {
        printf("Gathered values on root process:\n");
        for (int i = 0; i < size; i++) {
            printf("%d ", gathered_values[i]);
        }
        printf("\n");
    }
    MPI_Finalize();
    return 0;
}