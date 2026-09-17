// Lab 9 Q2: Row 0 stays same, row 1 squared, row 2 cubed, ...

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__device__ int ipow(int b, int e) {
    int r = 1;
    for (int i = 0; i < e; i++)
        r *= b;
    return r;
}

__global__ void rowPowers(int *a, int rows, int cols) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < rows && j < cols)
        a[i * cols + j] = ipow(a[i * cols + j], i + 1);
}

int main() {
    int rows, cols;
    printf("Enter rows cols: ");
    scanf("%d %d", &rows, &cols);
    int n = rows * cols;
    int *h = (int *)malloc(n * sizeof(int));
    printf("Enter A: ");
    for (int i = 0; i < n; i++)
        scanf("%d", &h[i]);

    int *d;
    cudaMalloc(&d, n * sizeof(int));
    cudaMemcpy(d, h, n * sizeof(int), cudaMemcpyHostToDevice);
    dim3 threads(16, 16);
    dim3 blocks((cols + 15) / 16, (rows + 15) / 16);
    rowPowers<<<blocks, threads>>>(d, rows, cols);
    cudaDeviceSynchronize();
    cudaMemcpy(h, d, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++)
            printf("%d ", h[i * cols + j]);
        printf("\n");
    }
    cudaFree(d);
    free(h);
    return 0;
}
