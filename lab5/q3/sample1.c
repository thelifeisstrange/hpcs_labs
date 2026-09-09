//Write an OpenMP program to find the sum of integers from 1 no N
//1) ising parallel for loop without reduction clause

#include <stdio.h>
#include <omp.h>

int main() {
    int n;
    printf("Enter the value of N: ");
    scanf("%d", &n);
    int sum = 0;
    #pragma omp parallel for shared(sum)
    for (int i = 1; i <= n; i++) {
        #pragma omp critical
        {
            sum += i;
        }
    }  
    printf("Sum of integers from 1 to %d is %d\n", n, sum);
    return 0;
}   