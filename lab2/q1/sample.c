//Write a MPI Program to simulate a calculator. Perform each operation using different processes in parallel

#include<stdio.h>
#include<stdlib.h>
#include<mpi.h>

int main(int argc, char *argv[]){

    int rank, size;
    int num1 = 5, num2 = 2, result;

  

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(size<4){

        printf("Please run the program using atleast 4 processes\n");
    }
    else{
        switch(rank){
        case 0:
            result = num1+ num2;
            printf("Process %d: %d + %d = %d\n", rank, num1, num2, result);
            break;
        case 1:
            result = num1- num2;
            printf("Process %d: %d - %d = %d\n", rank, num1, num2, result);
            break;
        case 2:
            result = num1* num2;
            printf("Process %d: %d * %d = %d\n", rank, num1, num2, result);
            break;
        case 3:
            if(num2==0){
                printf("Process %d: Divide by zero error", rank);
            }
            else{
                result = num1/ num2;
            printf("Process %d: %d / %d = %d\n", rank, num1, num2, result);
                
            }
            break;
        default:
            printf("Process %d:No operation assigned\n", rank);
    }
}
     MPI_Finalize();
    return 0;

}
   
