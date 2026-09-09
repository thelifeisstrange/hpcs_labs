// Write an Open MP program to sum the respective elements of the two arrays :
//1) Using number of threads equal to the  number of CPU Cores.


#include <stdio.h>
#include <omp.h>

int main() {
    int n = 10;
    int a[n], b[n], c[n];
    for (int i = 0; i < n; i++) {
        a[i] = i;
        b[i] = i;
    }

    printf("array a: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");
    printf("array b: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", b[i]);
    }
    printf("\n");
    #pragma omp parallel for
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
    printf("array c: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", c[i]);
    }
    printf("\n");
    return 0;
}