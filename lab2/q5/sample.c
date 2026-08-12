#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

// Simple helper function to check if a number is prime
int is_prime(int n) {
    if (n < 2) return 0; // 1 is not a prime number
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return 0; // Found a factor, not prime
    }
    return 1; // It is prime
}

int main(int argc, char *argv[]) {
    int rank;
    int buffer_size = 1024;
    char *buffer = (char *)malloc(buffer_size);

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Buffer_attach(buffer, buffer_size);

    if (rank == 0) {
        // 1. Process 0 calculates and prints primes from 1 to 50
        printf("Process 0 (Range 1-50) Prime Numbers: ");
        for (int i = 1; i <= 50; i++) {
            if (is_prime(i)) {
                printf("%d ", i);
            }
        }
        printf("\n");

        // 2. Send a dummy token to Process 1 via buffered send
        int token = 1;
        MPI_Bsend(&token, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } 
    else if (rank == 1) {
        int incoming_token;
        // 1. Wait until Process 0 finishes printing completely
        MPI_Recv(&incoming_token, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        // 2. Process 1 calculates and prints primes from 51 to 100
        printf("Process 1 (Range 51-100) Prime Numbers: ");
        for (int i = 51; i <= 100; i++) {
            if (is_prime(i)) {
                printf("%d ", i);
            }
        }
        printf("\n");
    }

    MPI_Buffer_detach(&buffer, &buffer_size);
    free(buffer);
    MPI_Finalize();
    return 0;
}
