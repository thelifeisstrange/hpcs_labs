//Write a MPI program to ead two strings S1 and S2 of same length in the root process. Using N process including the root (String length is evenly divisible by N) produce the concatnated resultant string as shown below. Display the resultant string in the root process.
//Eg. String S1: string      String S2: length.  Resultant String: slternigntgh

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, len, chunk;
    char s1[100], s2[100];
    char *s1_data = NULL, *s2_data = NULL;
    char *local_s1 = NULL, *local_s2 = NULL, *local_result = NULL;
    char *result = NULL;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter string S1: ");
        scanf("%s", s1);
        printf("Enter string S2: ");
        scanf("%s", s2);

        if (strcmp(s1, s2) == 0) {
            printf("Both strings must be different for interleaving.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        len = strlen(s1);
        if (strlen(s2) != len) {
            printf("Both strings must be of the same length.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        if (len % size != 0) {
            printf("String length must be divisible by number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        chunk = len / size;
        s1_data = (char *)malloc(len * sizeof(char));
        s2_data = (char *)malloc(len * sizeof(char));
        strcpy(s1_data, s1);
        strcpy(s2_data, s2);
    }

    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&chunk, 1, MPI_INT, 0, MPI_COMM_WORLD);

    local_s1 = (char *)malloc(chunk * sizeof(char));
    local_s2 = (char *)malloc(chunk * sizeof(char));
    MPI_Scatter(s1_data, chunk, MPI_CHAR, local_s1, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
    MPI_Scatter(s2_data, chunk, MPI_CHAR, local_s2, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);

    local_result = (char *)malloc((2 * chunk + 1) * sizeof(char));
    for (int i = 0; i < chunk; i++) {
        local_result[2 * i] = local_s1[i];
        local_result[2 * i + 1] = local_s2[i];
    }
    local_result[2 * chunk] = '\0';

    if (rank == 0) {
        result = (char *)malloc((2 * len + 1) * sizeof(char));
    }

    MPI_Gather(local_result, 2 * chunk, MPI_CHAR, result, 2 * chunk, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Resultant string: %s\n", result);
        free(result);
        free(s1_data);
        free(s2_data);
    }

    free(local_s1);
    free(local_s2);
    free(local_result);
    MPI_Finalize();
    return 0;
}
