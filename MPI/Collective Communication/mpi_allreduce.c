#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size;
    int local_value;
    int global_sum;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    // Each process sets its local value
    local_value = (rank + 1) * 2; // e.g., 2, 4, 6, ...
    // Allreduce: sum all local values and distribute result to all
    // processes
    MPI_Allreduce(&local_value, &global_sum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    // Each process prints the result
    printf("Process %d: local value = %d, global sum = %d\n", rank, local_value, global_sum);
    MPI_Finalize();
    return 0;
}