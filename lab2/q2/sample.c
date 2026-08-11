//write a mpi program of synschrnous send operation. The sender process sends a word to the reviever. The second process recieved teh word., toggles each letter of the world and sends back to the first process. Both process use synchronous send operations. 

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#include<mpi.h>

int main(int argc, char *argv[]){

    int rank, size;
    char message[6] = "HELLO";


    int len = strlen(message) + 1;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    if(rank==0){
        MPI_Ssend(message, len, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
        printf("Process %d: sent message %s\n", rank, message);
        MPI_Recv(message, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD, &status);
        printf("Process %d recieved message %s from %d\n", rank, message, status.MPI_SOURCE);
    }
    else{
        MPI_Recv(message, len, MPI_CHAR, 0, 0, MPI_COMM_WORLD, &status);
        printf("Process %d recieved message %s from %d\n", rank, message, status.MPI_SOURCE);

        for(int i=0; message[i] != '\0'; i++){
            message[i] = islower(message[i]) ? toupper(message[i]) : tolower(message[i]);
        }

        MPI_Ssend(message, len, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
        printf("Process %d: sending toggled message %s\n", rank, message);
    }

    MPI_Finalize();
    return 0;
}