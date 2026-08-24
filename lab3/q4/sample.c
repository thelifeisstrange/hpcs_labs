//Write a program to read value M and N x M number of elements in the root. Using N processes do the following task. Fing the square of first M numbers. Find the cube of next M numbers and so on. Print the results in root.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, M, N;
    int *data = NULL, *local = NULL;
    int *results = NULL;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter M: ");
        scanf("%d", &M);
        printf("Enter N (number of processes): ");
        scanf("%d", &N);

        if (N != size) {
            printf("N must match the number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        data = (int *)malloc((size * M) * sizeof(int));
        printf("Enter %d values:\n", size * M);
        for (int i = 0; i < size * M; i++) {
            scanf("%d", &data[i]);
        }
    }

    MPI_Bcast(&M, 1, MPI_INT, 0, MPI_COMM_WORLD);
    local = (int *)malloc(M * sizeof(int));
    MPI_Scatter(data, M, MPI_INT, local, M, MPI_INT, 0, MPI_COMM_WORLD);

    int *local_result = (int *)malloc(M * sizeof(int));
    for (int i = 0; i < M; i++) {
        int power = rank + 2;
        local_result[i] = (int)pow(local[i], power);
    }

    if (rank == 0) {
        results = (int *)malloc((size * M) * sizeof(int));
    }

    MPI_Gather(local_result, M, MPI_INT, results, M, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("\nFinal results:\n");
        for (int i = 0; i < size * M; i++) {
            printf("%d ", results[i]);
        }
        printf("\n");
        free(results);
        free(data);
    }

    free(local);
    free(local_result);
    MPI_Finalize();
    return 0;
}
