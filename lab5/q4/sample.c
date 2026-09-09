// q4) Write an OpenMP program to parallelize nested for loop for any program.
// Example: add two 2-D matrices using collapse(2) on the nested i/j loops.

#include <stdio.h>
#include <omp.h>

#define N 4

int main() {
    int a[N][N], b[N][N], c[N][N], owner[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            a[i][j] = i + j;
            b[i][j] = i * j;
        }
    }

    omp_set_num_threads(4);

    #pragma omp parallel for collapse(2)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            c[i][j] = a[i][j] + b[i][j];
            owner[i][j] = omp_get_thread_num();
        }
    }

    printf("Matrix A:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%3d ", a[i][j]);
        printf("\n");
    }

    printf("\nMatrix B:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%3d ", b[i][j]);
        printf("\n");
    }

    printf("\nMatrix C = A + B:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%3d ", c[i][j]);
        printf("\n");
    }

    printf("\nThread that computed each C[i][j]:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%3d ", owner[i][j]);
        printf("\n");
    }

    return 0;
}
