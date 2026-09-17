// Lab 4 Q1: 1! + 2! + ... + N! using MPI_Scan, with MPI error handling.

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, err;
    long long val, fact, prefix;

    MPI_Init(&argc, &argv);
    MPI_Errhandler_set(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    err = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (err != MPI_SUCCESS) {
        char msg[MPI_MAX_ERROR_STRING];
        int len;
        MPI_Error_string(err, msg, &len);
        printf("MPI_Comm_rank failed: %s\n", msg);
        MPI_Abort(MPI_COMM_WORLD, err);
    }
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    val = rank + 1;
    err = MPI_Scan(&val, &fact, 1, MPI_LONG_LONG, MPI_PROD, MPI_COMM_WORLD);
    if (err != MPI_SUCCESS) {
        char msg[MPI_MAX_ERROR_STRING];
        int len;
        MPI_Error_string(err, msg, &len);
        printf("Rank %d Scan error: %s\n", rank, msg);
    }
    MPI_Scan(&fact, &prefix, 1, MPI_LONG_LONG, MPI_SUM, MPI_COMM_WORLD);

    printf("Rank %d: %lld! = %lld, prefix = %lld\n", rank, val, fact, prefix);
    if (rank == size - 1)
        printf("1! + ... + %d! = %lld\n", size, prefix);

    MPI_Finalize();
    return 0;
}
