// Lab 2 Q2: Master (rank 0) sends a number to each slave using standard send.
// Slaves receive and print it.

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, x;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter a number: ");
        scanf("%d", &x);
        for (int i = 1; i < size; i++)
            MPI_Send(&x, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        printf("Master sent %d to %d slaves\n", x, size - 1);
    } else {
        MPI_Recv(&x, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Slave %d received %d\n", rank, x);
    }

    MPI_Finalize();
    return 0;
}
