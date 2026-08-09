//Process to process communication using buffered send and receive in MPI

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]) {

    int rank, size, send_number = 777;
    MPI_Status status;
    int buffer_size = 1024;
    char *buffer = (char *)malloc(buffer_size);

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size < 2) {
        fprintf(stderr, "Please run this program with at least 2 processes.\n");
        MPI_Finalize();
        free(buffer);
        return 1;
    }

    MPI_Buffer_attach(buffer, buffer_size);

    if (rank == 0) {
        MPI_Bsend(&send_number, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } else if (rank == 1) {
        MPI_Recv(&send_number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
        printf("Process %d received number %d from process %d in message %d\n",
               rank, send_number, status.MPI_SOURCE, status.MPI_TAG);
    }

    MPI_Buffer_detach(&buffer, &buffer_size);
    free(buffer);
    MPI_Finalize();
    return 0;
}
