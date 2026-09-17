// Lab 1 additional: reverse digits of an integer array of size 9 with 9 processes.

#include <stdio.h>
#include <mpi.h>

int reverseDigits(int n) {
    int sign = 1;
    if (n < 0) {
        sign = -1;
        n = -n;
    }
    int rev = 0;
    while (n > 0) {
        rev = rev * 10 + n % 10;
        n /= 10;
    }
    return sign * rev;
}

int main(int argc, char *argv[]) {
    int rank, size, local, result;
    int data[9] = {18, 523, 301, 1234, 2, 14, 108, 150, 1928};
    int out[9];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 9) {
        if (rank == 0)
            printf("Run with 9 processes: mpirun -np 9 ./sample.out\n");
        MPI_Finalize();
        return 0;
    }

    MPI_Scatter(data, 1, MPI_INT, &local, 1, MPI_INT, 0, MPI_COMM_WORLD);
    result = reverseDigits(local);
    MPI_Gather(&result, 1, MPI_INT, out, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Input:  ");
        for (int i = 0; i < 9; i++)
            printf("%d ", data[i]);
        printf("\nOutput: ");
        for (int i = 0; i < 9; i++)
            printf("%d ", out[i]);
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}
