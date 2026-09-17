// q3) Write a CUDA program to read a matrix A of size N x N. It replaces
// the principal diagonal elements with zero. Elements above the principal
// diagonal by their factorial and elements below the principal diagonal
// by their sum of digits.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__device__ int factorial(int n) {
    if (n < 0)
        return 0;
    int f = 1;
    for (int i = 2; i <= n; i++)
        f *= i;
    return f;
}

__device__ int sumOfDigits(int n) {
    if (n < 0)
        n = -n;
    int s = 0;
    while (n > 0) {
        s += n % 10;
        n /= 10;
    }
    return s;
}

__global__ void transformMatrix(int *a, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int row = idx / n;
    int col = idx % n;
    if (row < n && col < n) {
        int val = a[row * n + col];
        if (row == col)
            a[row * n + col] = 0;
        else if (col > row)
            a[row * n + col] = factorial(val);
        else
            a[row * n + col] = sumOfDigits(val);
    }
}

void printMatrix(int *mat, int n, const char *name) {
    printf("%s:\n", name);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            printf("%d ", mat[i * n + j]);
        printf("\n");
    }
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);

    int bytes = n * n * sizeof(int);
    int *h_a = (int *)malloc(bytes);

    printf("Enter %d x %d elements of A:\n", n, n);
    for (int i = 0; i < n * n; i++)
        scanf("%d", &h_a[i]);

    printMatrix(h_a, n, "A (before)");

    int *d_a;
    cudaMalloc(&d_a, bytes);
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);

    int total = n * n;
    int threads = 256;
    int blocks = (total + threads - 1) / threads;
    transformMatrix<<<blocks, threads>>>(d_a, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_a, d_a, bytes, cudaMemcpyDeviceToHost);

    printMatrix(h_a, n, "A (after)");

    cudaFree(d_a);
    free(h_a);
    return 0;
}
