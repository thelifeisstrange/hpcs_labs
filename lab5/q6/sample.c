// q6) Implement a parallel program to find the maximum element of an array
// using OpenMP.

#include <stdio.h>
#include <omp.h>

#define N 12

int main() {
    int a[N] = {4, 17, 9, 23, 5, 31, 8, 14, 2, 27, 11, 19};
    int max_val = a[0];

    printf("Array: ");
    for (int i = 0; i < N; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");

    omp_set_num_threads(4);

    #pragma omp parallel for reduction(max:max_val)
    for (int i = 0; i < N; i++) {
        if (a[i] > max_val)
            max_val = a[i];
    }

    printf("Maximum element = %d\n", max_val);

    return 0;
}
