// q1) Write a CUDA program to read matrix A of size M x N, read matrix B
// of size N x P. Perform C = A x B. Produce a resultant matrix C of size
// M x P in parallel. Also find the execution time taken by kernel and
// the whole program.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda_runtime.h>

__global__ void matMul(int *a, int *b, int *c, int m, int n, int p) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int row = idx / p;
    int col = idx % p;
    if (row < m && col < p) {
        int sum = 0;
        for (int k = 0; k < n; k++)
            sum += a[row * n + k] * b[k * p + col];
        c[row * p + col] = sum;
    }
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
    clock_t prog_start = clock();

    int m, n, p;
    printf("Enter M N P: ");
    scanf("%d %d %d", &m, &n, &p);

    int *h_a = (int *)malloc(m * n * sizeof(int));
    int *h_b = (int *)malloc(n * p * sizeof(int));
    int *h_c = (int *)malloc(m * p * sizeof(int));

    readMatrix(h_a, m, n, "A");
    readMatrix(h_b, n, p, "B");

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, m * n * sizeof(int));
    cudaMalloc(&d_b, n * p * sizeof(int));
    cudaMalloc(&d_c, m * p * sizeof(int));
    cudaMemcpy(d_a, h_a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, n * p * sizeof(int), cudaMemcpyHostToDevice);

    int total = m * p;
    int threads = 256;
    int blocks = (total + threads - 1) / threads;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    if (total > 0)
        matMul<<<blocks, threads>>>(d_a, d_b, d_c, m, n, p);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float kernel_ms = 0;
    cudaEventElapsedTime(&kernel_ms, start, stop);

    cudaMemcpy(h_c, d_c, m * p * sizeof(int), cudaMemcpyDeviceToHost);

    clock_t prog_end = clock();
    double prog_ms = 1000.0 * (double)(prog_end - prog_start) / CLOCKS_PER_SEC;

    printMatrix(h_a, m, n, "A");
    printMatrix(h_b, n, p, "B");
    printMatrix(h_c, m, p, "C = A x B");
    printf("Kernel time: %.6f ms\n", kernel_ms);
    printf("Program time: %.6f ms\n", prog_ms);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
