//write a program in MPI where even ranked process return factorial and odd ranked process returns fibionacci number of the rank 

#include<mpi.h>
#include<stdio.h>

int factorial(int n){
    int result = 1;
    if (n==0 || n==1){
        return 1;
    } 
    else{
        for(int i=2; i<=n; i++){
            result *= i;
        }
        return result;
    }
}

int fibionacci(int n){
    int a = 0, b = 1, c;
    for(int i=2; i<=n; i++){
        c = a+b;
        a = b;
        b = c;  
    }
    return b;
}

int main(int argc, char *argv[]){
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank%2 ==0){
        printf("Process %d: Factoral of %d = %d \n", rank, rank, factorial(rank));
    }
    else{
        printf("Process %d: Finionacci of %d = %d \n", rank, rank, fibionacci(rank));

    }
    MPI_Finalize();
    return 0;
}