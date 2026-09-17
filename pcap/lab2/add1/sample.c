// Lab 2 additional: Root reads N array elements. N processes check
// whether each value is prime.

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int isPrime(int n) {
    if (n <= 1)
        return 0;
    for (int i = 2; i * i <= n; i++)
        if (n % i == 0)
            return 0;
    return 1;
}

int main(int argc, char *argv[]) {
    int rank, size, val, prime;
    int *data = NULL, *flags = NULL;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        data = (int *)malloc(size * sizeof(int));
        flags = (int *)malloc(size * sizeof(int));
        printf("Enter %d elements: ", size);
        for (int i = 0; i < size; i++)
            scanf("%d", &data[i]);
    }

    MPI_Scatter(data, 1, MPI_INT, &val, 1, MPI_INT, 0, MPI_COMM_WORLD);
    prime = isPrime(val);
    MPI_Gather(&prime, 1, MPI_INT, flags, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        for (int i = 0; i < size; i++)
            printf("%d is %s\n", data[i], flags[i] ? "prime" : "not prime");
        free(data);
        free(flags);
    }

    MPI_Finalize();
    return 0;
}
