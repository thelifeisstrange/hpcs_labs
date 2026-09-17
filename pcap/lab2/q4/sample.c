// Lab 2 Q4: Root reads an integer and sends it around a ring.
// Each process increments the value before forwarding. Last process
// sends it back to root.

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, x;
    int next, prev;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    next = (rank + 1) % size;
    prev = (rank - 1 + size) % size;

    if (rank == 0) {
        printf("Enter an integer: ");
        scanf("%d", &x);
        printf("Root starts with %d\n", x);
        MPI_Send(&x, 1, MPI_INT, next, 0, MPI_COMM_WORLD);
        MPI_Recv(&x, 1, MPI_INT, prev, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Root received final value %d\n", x);
    } else {
        MPI_Recv(&x, 1, MPI_INT, prev, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        x++;
        printf("Rank %d incremented to %d\n", rank, x);
        MPI_Send(&x, 1, MPI_INT, next, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
