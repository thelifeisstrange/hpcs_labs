// Lab 3 Q3: Count non-vowels in a string using N processes.
// String length is evenly divisible by N.

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <mpi.h>

int isVowel(char c) {
    c = (char)tolower((unsigned char)c);
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
}

int main(int argc, char *argv[]) {
    int rank, size, chunk, local = 0, total = 0;
    int counts[256];
    char s[1024];
    char part[1024];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter a string (length divisible by %d): ", size);
        scanf("%s", s);
        chunk = (int)strlen(s) / size;
    }
    MPI_Bcast(&chunk, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(s, chunk, MPI_CHAR, part, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);

    for (int i = 0; i < chunk; i++)
        if (!isVowel(part[i]) && ((part[i] >= 'A' && part[i] <= 'Z') || (part[i] >= 'a' && part[i] <= 'z')))
            local++;

    MPI_Gather(&local, 1, MPI_INT, counts, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Reduce(&local, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        for (int i = 0; i < size; i++)
            printf("Process %d non-vowels: %d\n", i, counts[i]);
        printf("Total non-vowels: %d\n", total);
    }

    MPI_Finalize();
    return 0;
}
