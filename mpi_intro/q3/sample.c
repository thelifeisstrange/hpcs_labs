//write a prog in MPI to simulate a simple calculator to perform each operation using differnt process in parallel

#include<mpi.h>
#include<stdio.h>
int main(int argc, char *argv[])
{
    int rank, size;
    int a = 10, b = 5, result;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);       
    if(size < 4) {
        if(rank == 0) {
            printf("Please run the program with at least 4 processes.\n");
        }
    } else {
        switch(rank) {
            case 0: // Addition
                result = a + b;
                printf("Process %d: %d + %d = %d\n", rank, a, b, result);
                break;
            case 1: // Subtraction
                result = a - b;
                printf("Process %d: %d - %d = %d\n", rank, a, b, result);
                break;
            case 2: // Multiplication
                result = a * b;
                printf("Process %d: %d * %d = %d\n", rank, a, b, result);
                break;
            case 3: // Division
                if(b != 0) {
                    result = a / b;
                    printf("Process %d: %d / %d = %d\n", rank, a, b, result);
                } else {
                    printf("Process %d: Division by zero error!\n", rank);
                }
                break;
            default:
                printf("Process %d: No operation assigned.\n", rank);
        }
    }
    MPI_Finalize();
    return 0;
}   