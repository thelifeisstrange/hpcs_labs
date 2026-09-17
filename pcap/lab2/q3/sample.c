// Lab 2 Q3: Root reads N elements (N = number of processes) and sends one
// value to each slave with MPI_Bsend. Even ranks square, odd ranks cube.

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, val, result;
    int *data = NULL;
    int bufsize;
    void *buf;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Pack_size(1, MPI_INT, MPI_COMM_WORLD, &bufsize);
    bufsize = size * (bufsize + MPI_BSEND_OVERHEAD);
    buf = malloc(bufsize);
    MPI_Buffer_attach(buf, bufsize);

    if (rank == 0) {
        data = (int *)malloc(size * sizeof(int));
        printf("Enter %d elements: ", size);
        for (int i = 0; i < size; i++)
            scanf("%d", &data[i]);
        for (int i = 0; i < size; i++)
            MPI_Bsend(&data[i], 1, MPI_INT, i, 0, MPI_COMM_WORLD);
    }

    MPI_Recv(&val, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    if (rank % 2 == 0)
        result = val * val;
    else
        result = val * val * val;
    printf("Rank %d got %d -> %d\n", rank, val, result);

    MPI_Buffer_detach(&buf, &bufsize);
    free(buf);
    if (rank == 0)
        free(data);
    MPI_Finalize();
    return 0;
}
