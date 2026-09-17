// Lab 2 additional: Using N processes, compute
// 1! + (1+2) + 3! + (1+2+3+4) + 5! + (1+2+3+4+5+6) + ...
// Even ranks (0,2,4,...) compute (rank+1)!
// Odd ranks compute the sum 1 + 2 + ... + (rank+1).

#include <stdio.h>
#include <mpi.h>

long long factorial(int n) {
    long long f = 1;
    for (int i = 2; i <= n; i++)
        f *= i;
    return f;
}

int main(int argc, char *argv[]) {
    int rank, size;
    long long local, total;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int n = rank + 1;
    if (rank % 2 == 0)
        local = factorial(n);
    else {
        local = 0;
        for (int i = 1; i <= n; i++)
            local += i;
    }

    MPI_Reduce(&local, &total, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
    printf("Rank %d term = %lld\n", rank, local);
    if (rank == 0)
        printf("Result = %lld\n", total);

    MPI_Finalize();
    return 0;
}
