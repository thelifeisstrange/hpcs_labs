#include <stdio.h>
#include <mpi.h>

#define N 10 // Total array size

int main(int argc, char *argv[]) {
    int rank;
    int a[10] = {5, 12, 3, 25, 8, 14, 7, 20, 1, 15}; // Hardcoded array
    int subarray[5];                                 // To hold half the elements
    int target = 20;                                 // Number we want to find
    int foundIndex = -1;                             // -1 means not found yet

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        // 1. Print the target and array details
        printf("Process 0: Searching for the number: %d\n", target);
        printf("Process 0: Array elements: ");
        for (int i = 0; i < N; i++) {
            printf("%d ", a[i]);
        }
        printf("\n");

        // 2. Copy the first half into local subarray
        for (int i = 0; i < 5; i++) {
            subarray[i] = a[i];
        }

        // 3. Send the second half to Process 1
        MPI_Send(&a[5], 5, MPI_INT, 1, 0, MPI_COMM_WORLD);

        // 4. Process 0 searches its own half (indices 0 to 4)
        for (int i = 0; i < 5; i++) {
            if (subarray[i] == target) {
                foundIndex = i; // Save the global index match
                break;
            }
        }

        // 5. Receive the search result from Process 1
        int rank1_index = -1;
        MPI_Recv(&rank1_index, 1, MPI_INT, 1, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        // 6. Root process evaluates both results and prints the outcome
        if (foundIndex != -1) {
            printf("Root Process 0: Number %d found at global index %d\n", target, foundIndex);
        } 
        else if (rank1_index != -1) {
            printf("Root Process 0: Number %d found at global index %d\n", target, rank1_index);
        } 
        else {
            printf("Root Process 0: Number %d was NOT found in the array.\n", target);
        }

    } 
    else if (rank == 1) {
        // 1. Receive the second half of elements
        MPI_Recv(subarray, 5, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        // 2. Process 1 searches its half (maps to global indices 5 to 9)
        for (int i = 0; i < 5; i++) {
            if (subarray[i] == target) {
                foundIndex = 5 + i; // Offset by 5 to get the correct global index position
                break;
            }
        }

        // 3. Send the found global index (or -1) back to Process 0
        MPI_Send(&foundIndex, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
