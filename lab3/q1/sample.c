//write a MPI Program to read N values in the root process. Root process sends one value to each process. Every process recieves it prints the factorial of that number. Use N number of processes.

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

long long factorial(int n) {
    long long fact = 1;
    for (int i = 2; i <= n; i++) {
        fact *= i;
    }
    return fact;
}

int main(int argc, char *argv[]) {
    int rank, size, N;
    int *data = NULL;
    int local_value;
    long long local_fact, *results = NULL;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter N (must be equal to number of processes): ");
        scanf("%d", &N);
        if (N != size) {
            printf("N must match the number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        data = (int *)malloc(N * sizeof(int));
        printf("Enter %d values:\n", N);
        for (int i = 0; i < N; i++) {
            scanf("%d", &data[i]);
        }
    }

    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(data, 1, MPI_INT, &local_value, 1, MPI_INT, 0, MPI_COMM_WORLD);

    local_fact = factorial(local_value);

    if (rank == 0) {
        results = (long long *)malloc(N * sizeof(long long));
    }

    MPI_Gather(&local_fact, 1, MPI_LONG_LONG, results, 1, MPI_LONG_LONG, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("\nFactorials:\n");
        for (int i = 0; i < N; i++) {
            printf("Value %d -> %lld\n", data[i], results[i]);
        }
        free(results);
        free(data);
    }

    MPI_Finalize();
    return 0;
}
