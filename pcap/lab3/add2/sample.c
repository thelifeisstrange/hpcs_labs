// Lab 3 additional: Replace even elements with 1 and odd elements with 0.
// Count even and odd numbers in the root. N is evenly divisible by process count.

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, n, chunk;
    int *a = NULL, *b = NULL;
    int *part, *outpart;
    int even = 0, odd = 0, teven = 0, todd = 0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter N (divisible by %d): ", size);
        scanf("%d", &n);
        a = (int *)malloc(n * sizeof(int));
        b = (int *)malloc(n * sizeof(int));
        printf("Enter %d elements: ", n);
        for (int i = 0; i < n; i++)
            scanf("%d", &a[i]);
        chunk = n / size;
    }
    MPI_Bcast(&chunk, 1, MPI_INT, 0, MPI_COMM_WORLD);
    part = (int *)malloc(chunk * sizeof(int));
    outpart = (int *)malloc(chunk * sizeof(int));
    MPI_Scatter(a, chunk, MPI_INT, part, chunk, MPI_INT, 0, MPI_COMM_WORLD);

    for (int i = 0; i < chunk; i++) {
        if (part[i] % 2 == 0) {
            outpart[i] = 1;
            even++;
        } else {
            outpart[i] = 0;
            odd++;
        }
    }

    MPI_Gather(outpart, chunk, MPI_INT, b, chunk, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Reduce(&even, &teven, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    MPI_Reduce(&odd, &todd, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Result: ");
        for (int i = 0; i < n; i++)
            printf("%d ", b[i]);
        printf("\nEven count = %d\nOdd count = %d\n", teven, todd);
        free(a);
        free(b);
    }
    free(part);
    free(outpart);
    MPI_Finalize();
    return 0;
}
