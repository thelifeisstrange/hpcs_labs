// q7) Create a program where multiple threads calculate factorial of
// different numbers in parallel.

#include <stdio.h>
#include <omp.h>

long long factorial(int n) {
    long long f = 1;
    for (int i = 2; i <= n; i++)
        f *= i;
    return f;
}

int main() {
    int nums[] = {5, 6, 7, 8};
    int n = 4;
    long long results[4];

    omp_set_num_threads(n);

    #pragma omp parallel
    {
        int tid = omp_get_thread_num();
        results[tid] = factorial(nums[tid]);
        printf("Thread %d: %d! = %lld\n", tid, nums[tid], results[tid]);
    }

    return 0;
}
