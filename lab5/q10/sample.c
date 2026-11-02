// 2) Read a matrix; find max of each row and each column (parallel for).
// Sample 4x4 output shown.

#include <stdio.h>
#include <omp.h>

#define N 4

int main(void)
{
    int a[N][N] = {
        {3, 8, 1, 4},
        {7, 2, 9, 5},
        {6, 0, 4, 8},
        {1, 5, 3, 2}
    };
    int row_max[N], col_max[N];

    printf("Matrix:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%3d ", a[i][j]);
        printf("\n");
    }

    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        int m = a[i][0];
        for (int j = 1; j < N; j++)
            if (a[i][j] > m)
                m = a[i][j];
        row_max[i] = m;
    }

    #pragma omp parallel for
    for (int j = 0; j < N; j++) {
        int m = a[0][j];
        for (int i = 1; i < N; i++)
            if (a[i][j] > m)
                m = a[i][j];
        col_max[j] = m;
    }

    printf("\nRow max: ");
    for (int i = 0; i < N; i++)
        printf("%d ", row_max[i]);
    printf("\nCol max: ");
    for (int j = 0; j < N; j++)
        printf("%d ", col_max[j]);
    printf("\n");
    return 0;
}
