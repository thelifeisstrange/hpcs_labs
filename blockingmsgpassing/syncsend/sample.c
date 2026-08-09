//Synchronous send in MPI in C

#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc, char *argv[]){

    int rank, size, send_number = 777;
    MPI_Status status;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank==0){
        MPI_Ssend(&send_number, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    }
    else if(rank==1){
        MPI_Recv(&send_number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
        printf("Process %d recieved number %d from process %d in message %d\n", rank, send_number, status.MPI_SOURCE, status.MPI_TAG);
    }
        MPI_Finalize();
    return 0;
}
    

    