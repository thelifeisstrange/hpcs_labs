// Lab 9 additional: B[i][j] = (sum of row i) + (sum of column j).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void rowColSum(int *a, int *b, int rows, int cols) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= rows || j >= cols)
        return;
    int rs = 0, cs = 0;
    for (int k = 0; k < cols; k++)
        rs += a[i * cols + k];
    for (int k = 0; k < rows; k++)
        cs += a[k * cols + j];
    b[i * cols + j] = rs + cs;
}

int main() {
    int rows, cols;
    printf("Enter rows cols: ");
    scanf("%d %d", &rows, &cols);
    int n = rows * cols;
    int *h_a = (int *)malloc(n * sizeof(int));
    int *h_b = (int *)malloc(n * sizeof(int));
    printf("Enter A: ");
    for (int i = 0; i < n; i++)
        scanf("%d", &h_a[i]);

    int *d_a, *d_b;
    cudaMalloc(&d_a, n * sizeof(int));
    cudaMalloc(&d_b, n * sizeof(int));
    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);
    dim3 threads(16, 16);
    dim3 blocks((cols + 15) / 16, (rows + 15) / 16);
    rowColSum<<<blocks, threads>>>(d_a, d_b, rows, cols);
    cudaDeviceSynchronize();
    cudaMemcpy(h_b, d_b, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("B:\n");
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++)
            printf("%d ", h_b[i * cols + j]);
        printf("\n");
    }
    cudaFree(d_a);
    cudaFree(d_b);
    free(h_a);
    free(h_b);
    return 0;
}
