//write a program in MPI to find out pow(x,rank) for all processes where 'x' constant and 'rank' is the rank of each process

#include<mpi.h>
#include<stdio.h>
#include<math.h>
int main(int argc, char *argv[])
{
    int rank, size;
    double x = 2.0; // constant value
    double result;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    result = pow(x, rank);
    printf("The pow with const 2 rank is %.0f in pid %d in total %d processes\n", result, rank, size);
    MPI_Finalize();
    return 0;
}   