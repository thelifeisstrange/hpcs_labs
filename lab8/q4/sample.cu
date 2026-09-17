// q4) Write a program in CUDA to implement matrix addition and
// multiplication using 2D grids and 2D blocks.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void matAdd2D(int *a, int *b, int *c, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < n && col < n)
        c[row * n + col] = a[row * n + col] + b[row * n + col];
}

__global__ void matMul2D(int *a, int *b, int *c, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < n && col < n) {
        int sum = 0;
        for (int k = 0; k < n; k++)
            sum += a[row * n + k] * b[k * n + col];
        c[row * n + col] = sum;
    }
}

void readMatrix(int *mat, int n, const char *name) {
    printf("Enter %d x %d elements of %s:\n", n, n, name);
    for (int i = 0; i < n * n; i++)
        scanf("%d", &mat[i]);
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
    printf("Enter N (square matrices): ");
    scanf("%d", &n);

    int bytes = n * n * sizeof(int);
    int *h_a = (int *)malloc(bytes);
    int *h_b = (int *)malloc(bytes);
    int *h_add = (int *)malloc(bytes);
    int *h_mul = (int *)malloc(bytes);

    readMatrix(h_a, n, "A");
    readMatrix(h_b, n, "B");

    int *d_a, *d_b, *d_add, *d_mul;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_add, bytes);
    cudaMalloc(&d_mul, bytes);
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    dim3 threads(16, 16);
    dim3 blocks((n + threads.x - 1) / threads.x,
                (n + threads.y - 1) / threads.y);

    matAdd2D<<<blocks, threads>>>(d_a, d_b, d_add, n);
    matMul2D<<<blocks, threads>>>(d_a, d_b, d_mul, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_add, d_add, bytes, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_mul, d_mul, bytes, cudaMemcpyDeviceToHost);

    printMatrix(h_a, n, "A");
    printMatrix(h_b, n, "B");
    printMatrix(h_add, n, "C = A + B (2D grid/blocks)");
    printMatrix(h_mul, n, "D = A x B (2D grid/blocks)");

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_add);
    cudaFree(d_mul);
    free(h_a);
    free(h_b);
    free(h_add);
    free(h_mul);
    return 0;
}
