// 2) Write a MPI program to read a 3 x 3 matrix. Enter an element to be searched
// in the root process. Find the number of occurrences of this element in the
// matrix using three processes.

#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    int matrix[3][3];
    int local_row[3];
    int key, local_count = 0, total_count = 0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 3) {
        if (rank == 0) {
            printf("Run this program with 3 processes: mpirun -np 3 ./sample.out\n");
        }
        MPI_Finalize();
        return 0;
    }

    if (rank == 0) {
        printf("Enter 3 x 3 matrix:\n");
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                scanf("%d", &matrix[i][j]);
            }
        }
        printf("Enter the element to be searched: ");
        scanf("%d", &key);
    }

    MPI_Bcast(&key, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scatter(matrix, 3, MPI_INT, local_row, 3, MPI_INT, 0, MPI_COMM_WORLD);

    for (int i = 0; i < 3; i++) {
        if (local_row[i] == key) {
            local_count++;
        }
    }

    printf("Process %d found %d occurrence(s) in its row\n", rank, local_count);

    MPI_Reduce(&local_count, &total_count, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Total number of occurrences of %d = %d\n", key, total_count);
    }

    MPI_Finalize();
    return 0;
}
