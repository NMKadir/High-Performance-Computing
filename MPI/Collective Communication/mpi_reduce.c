#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size, local_value, global_sum;
    MPI_Init(&argc, &argv); // Initialize MPI environment
    MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Get current process rank
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Get total number of processes
    local_value = rank + 1; // Example: each process holds its rank+1 as value
    // Reduce: compute the sum of local_value from all processes into global_sum at root (rank 0)
    MPI_Reduce(&local_value, &global_sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    if (rank == 0) {
        printf("Total sum of all values = %d\n", global_sum);
    }
    MPI_Finalize(); // Finalize the MPI environment
    return 0;
}