// 4) Write a MPI program to read a word of length N. Using N processes including
// the root get output word with the pattern as shown in example. Display the
// resultant output word in the root. Calculate the amount of time taken by each
// process and the whole program.
// Eg: Input : PCAP    Output : PCCAAAPPPP

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, N;
    char word[100];
    char *local = NULL, *result = NULL;
    int *recvcounts = NULL, *displs = NULL;
    double p_start, p_end, t_start, t_end;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter a word of length %d (equal to number of processes): ", size);
        scanf("%s", word);
        N = (int)strlen(word);
        if (N != size) {
            printf("Word length must be equal to the number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
    }

    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(word, N, MPI_CHAR, 0, MPI_COMM_WORLD);

    MPI_Barrier(MPI_COMM_WORLD);
    t_start = MPI_Wtime();
    p_start = MPI_Wtime();

    /* Character at index i (0-based) is repeated (i+1) times */
    int my_len = rank + 1;
    local = (char *)malloc((my_len + 1) * sizeof(char));
    for (int i = 0; i < my_len; i++) {
        local[i] = word[rank];
    }
    local[my_len] = '\0';

    if (rank == 0) {
        int total = N * (N + 1) / 2;
        result = (char *)malloc((total + 1) * sizeof(char));
        recvcounts = (int *)malloc(N * sizeof(int));
        displs = (int *)malloc(N * sizeof(int));
        int pos = 0;
        for (int i = 0; i < N; i++) {
            recvcounts[i] = i + 1;
            displs[i] = pos;
            pos += i + 1;
        }
    }

    MPI_Gatherv(local, my_len, MPI_CHAR, result, recvcounts, displs, MPI_CHAR, 0, MPI_COMM_WORLD);

    p_end = MPI_Wtime();
    printf("Process %d: '%c' x %d = %s, time = %lf seconds\n",
           rank, word[rank], my_len, local, p_end - p_start);

    MPI_Barrier(MPI_COMM_WORLD);
    t_end = MPI_Wtime();

    if (rank == 0) {
        result[N * (N + 1) / 2] = '\0';
        printf("\nResultant output word: %s\n", result);
        printf("Whole program time = %lf seconds\n", t_end - t_start);
        free(result);
        free(recvcounts);
        free(displs);
    }

    free(local);
    MPI_Finalize();
    return 0;
}
