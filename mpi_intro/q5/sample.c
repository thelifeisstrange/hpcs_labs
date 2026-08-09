#include <mpi.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int rank, size;
    char s[] = "HELLO";

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int len = strlen(s);

    if(rank < len) {
        char c = s[rank];
        if(islower(c)) {
            s[rank] = toupper(c);
        } else {
            s[rank] = tolower(c);
        }
    

    printf("Process %d toggled '%c' to '%c'\n", rank, c, s[rank]);
    }
    MPI_Finalize();
    return 0;
}