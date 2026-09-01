// 3) Write a MPI program to read 4 x 4 matrix display the following output using four processes
// I/p:
// 1 2 3 4
// 1 2 3 1
// 1 1 1 1
// 2 1 2 1
// O/p:
// 1 2 3 4
// 2 4 6 5
// 3 5 7 6
// 5 6 9 7

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    int matrix[4][4];
    int local_row[4], scan_row[4];
    int result[4][4];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 4) {
        if (rank == 0) {
            printf("Run this program with 4 processes: mpirun -np 4 ./sample.out\n");
        }
        MPI_Finalize();
        return 0;
    }

    if (rank == 0) {
        printf("Enter 4 x 4 matrix:\n");
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                scanf("%d", &matrix[i][j]);
            }
        }
    }

    MPI_Scatter(matrix, 4, MPI_INT, local_row, 4, MPI_INT, 0, MPI_COMM_WORLD);

    /* Inclusive prefix sum along each column (one row per process) */
    MPI_Scan(local_row, scan_row, 4, MPI_INT, MPI_SUM, MPI_COMM_WORLD);

    MPI_Gather(scan_row, 4, MPI_INT, result, 4, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("\nOutput matrix:\n");
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                printf("%d ", result[i][j]);
            }
            printf("\n");
        }
    }

    MPI_Finalize();
    return 0;
}
