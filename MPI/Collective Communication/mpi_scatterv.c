//uneven distribution of data from root to all processes.
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
    int rank, size;
    int send_data[10]; // Total elements to scatter
    int recv_count; // Number of elements this process will receive
    int recv_data[4]; // Maximum any process might receive (4 in this case)
    // Displacements and counts for each process
    int counts[4] = {1, 2, 3, 4}; // Elements per process
    int displs[4] = {0, 1, 3, 6}; // Displacement in send_data
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (size != 4) {
        if (rank == 0)
            printf("Please run with 4 processes.\n");
    MPI_Finalize();
    return 0;
    }
    // Initialize data on root
    if (rank == 0) {    
        for (int i = 0; i < 10; i++) {
            send_data[i] = (i + 1) * 10; // 10, 20, ..., 100
        }
    }
    // Set how many elements this process
    // should receive
    recv_count = counts[rank];
    // Scatterv
    MPI_Scatterv(send_data, counts, displs, MPI_INT, recv_data, recv_count, MPI_INT, 0, MPI_COMM_WORLD);
    // Print received data
    printf("Process %d received:", rank);
    for (int i = 0; i < recv_count; i++) {
        printf(" %d", recv_data[i]);
    }
    printf("\n");
    MPI_Finalize();
    return 0;
}