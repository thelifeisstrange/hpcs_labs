//write a MPI program to read values M and M x N elements in teh root process. Root process sends M elements to each process. Each process fonda average of M elements it recieved and send these avegage of M elements it recieved and send these avegeage to root. Root collects the value and finds the total average. Use N number of processes.

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, M, N;
    int *data = NULL, *local = NULL;
    double *averages = NULL, local_avg, total_avg;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter M: ");
        scanf("%d", &M);
        printf("Enter N (number of processes): ");
        scanf("%d", &N);

        if (N != size) {
            printf("N must match the number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        data = (int *)malloc((size * M) * sizeof(int));
        printf("Enter %d values:\n", size * M);
        for (int i = 0; i < size * M; i++) {
            scanf("%d", &data[i]);
        }
    }

    MPI_Bcast(&M, 1, MPI_INT, 0, MPI_COMM_WORLD);
    local = (int *)malloc(M * sizeof(int));
    MPI_Scatter(data, M, MPI_INT, local, M, MPI_INT, 0, MPI_COMM_WORLD);

    double sum = 0.0;
    for (int i = 0; i < M; i++) {
        sum += local[i];
    }
    local_avg = sum / M;

    if (rank == 0) {
        averages = (double *)malloc(size * sizeof(double));
    }

    MPI_Gather(&local_avg, 1, MPI_DOUBLE, averages, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        double total = 0.0;
        for (int i = 0; i < size; i++) {
            total += averages[i];
            printf("Process %d average = %.2f\n", i, averages[i]);
        }
        total_avg = total / size;
        printf("Total average = %.2f\n", total_avg);
        free(averages);
        free(data);
    }

    free(local);
    MPI_Finalize();
    return 0;
}
