#include<stdio.h>
#include<mpi.h>
#include<stdlib.h>

#define N 10 // FIXED: Defined N so it can be used for loops

int main(int argc, char *argv[]){
    int rank; // FIXED: Separated from array declaration syntax
    int a[10] = {5, 12, 3, 25, 8, 14, 7, 20, 1, 15};
    int subarray[5];
    int localSum = 0; // FIXED: Added missing data type 'int'
    int totalSum = 0; // FIXED: Added missing data type 'int'

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    int half = N/2;
    MPI_Status status; // FIXED: Changed MPI_STATUS to MPI_Status

    if (rank == 0) {
        // print array
        printf("Process 0: Array elements: ");
        for(int i=0; i<N; i++){
            printf("%d ", a[i]);
        }
        printf("\n");

        // copying first half into subarray
        for(int i=0; i<5; i++){
            subarray[i] = a[i]; // FIXED: Added missing semicolon
        }

        MPI_Ssend(&a[5], 5, MPI_INT, 1, 0, MPI_COMM_WORLD);

        for(int i=0; i<5; i++){ // FIXED: Changed comma to semicolon
            localSum += subarray[i]; // FIXED: Changed localsum to localSum
        }
        printf("Process %d: First half sum = %d\n", rank, localSum);

        int recvSum = 0;
        MPI_Recv(&recvSum, 1, MPI_INT, 1, 1, MPI_COMM_WORLD, &status);
        printf("Process %d Received second half sum %d from process %d\n", rank, recvSum, status.MPI_SOURCE);

        totalSum = localSum + recvSum;
        printf("Process %d: Grand Total = %d\n", rank, totalSum);
    } 
    else if(rank == 1){
        MPI_Recv(subarray, 5, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
        
        for (int i = 0; i < 5; i++) {
            localSum += subarray[i]; // FIXED: Changed sub_array to subarray
        }
        printf("Process 1: Second half sum = %d\n", localSum);
        
        // FIXED: Changed local_sum to localSum to match declaration
        MPI_Send(&localSum, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
