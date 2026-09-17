// q2c) Add two matrices. Each element of the resultant matrix is computed
// by one thread.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void addByElement(int *a, int *b, int *c, int rows, int cols) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total = rows * cols;
    if (idx < total)
        c[idx] = a[idx] + b[idx];
}

void readMatrix(int *mat, int rows, int cols, const char *name) {
    printf("Enter %d x %d elements of %s:\n", rows, cols, name);
    for (int i = 0; i < rows * cols; i++)
        scanf("%d", &mat[i]);
}

void printMatrix(int *mat, int rows, int cols, const char *name) {
    printf("%s:\n", name);
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++)
            printf("%d ", mat[i * cols + j]);
        printf("\n");
    }
}

int main() {
    int rows, cols;
    printf("Enter rows and cols: ");
    scanf("%d %d", &rows, &cols);

    int bytes = rows * cols * sizeof(int);
    int *h_a = (int *)malloc(bytes);
    int *h_b = (int *)malloc(bytes);
    int *h_c = (int *)malloc(bytes);

    readMatrix(h_a, rows, cols, "A");
    readMatrix(h_b, rows, cols, "B");

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    int total = rows * cols;
    int threads = 256;
    int blocks = (total + threads - 1) / threads;
    addByElement<<<blocks, threads>>>(d_a, d_b, d_c, rows, cols);
    cudaDeviceSynchronize();

    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    printMatrix(h_a, rows, cols, "A");
    printMatrix(h_b, rows, cols, "B");
    printMatrix(h_c, rows, cols, "C = A + B (one thread per element)");

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
