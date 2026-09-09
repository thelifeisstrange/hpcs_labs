//Write an OpenMP program to find the sum of integers from 1 no N
//1) Using reductionclause in parallel for loop 

#include <stdio.h>
#include <omp.h>

int main() {
    int n;
    printf("Enter the value of N: ");
    scanf("%d", &n);
    int sum = 0;
    #pragma omp parallel for reduction(+:sum)
    for (int i = 1; i <= n; i++) {
        sum += i;
    }  
    printf("Sum of integers from 1 to %d is %d\n", n, sum);
    return 0;
}   

