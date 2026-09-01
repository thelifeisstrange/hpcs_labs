// 1) Write a MPI program using N processes to find 1! + 2! + .....+ N!.
// Use MPI_Scan. Calculate the amount of time taken by each process and the whole program.

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    long long val, fact, prefix_sum;
    double p_start, p_end, t_start, t_end;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Barrier(MPI_COMM_WORLD);
    t_start = MPI_Wtime();
    p_start = MPI_Wtime();

    /* Process i holds (i+1). Scan with product gives (i+1)! */
    val = rank + 1;
    MPI_Scan(&val, &fact, 1, MPI_LONG_LONG, MPI_PROD, MPI_COMM_WORLD);

    /* Scan with sum gives 1! + 2! + ... + (rank+1)! */
    MPI_Scan(&fact, &prefix_sum, 1, MPI_LONG_LONG, MPI_SUM, MPI_COMM_WORLD);

    p_end = MPI_Wtime();
    printf("Process %d: %lld! = %lld, prefix sum = %lld, time = %lf seconds\n",
           rank, val, fact, prefix_sum, p_end - p_start);

    MPI_Barrier(MPI_COMM_WORLD);
    t_end = MPI_Wtime();

    if (rank == size - 1) {
        printf("\n1! + 2! + ... + %d! = %lld\n", size, prefix_sum);
    }

    if (rank == 0) {
        printf("Whole program time = %lf seconds\n", t_end - t_start);
    }

    MPI_Finalize();
    return 0;
}
