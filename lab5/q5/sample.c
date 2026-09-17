// q5) Write an OpenMP program to compute the sum of the first 100 integers
// using a parallel for loop.

#include <stdio.h>
#include <omp.h>

int main() {
    int n = 100;
    int sum = 0;

    omp_set_num_threads(4);

    #pragma omp parallel for reduction(+:sum)
    for (int i = 1; i <= n; i++) {
        sum += i;
    }

    printf("Sum of the first %d integers = %d\n", n, sum);
    printf("Expected (n*(n+1)/2) = %d\n", n * (n + 1) / 2);

    return 0;
}
