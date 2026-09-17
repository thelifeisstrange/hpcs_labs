// Lab 9 Q3: 1's complement of non-border elements (bit-string invert, read as decimal).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__device__ int onesCompDecimal(int n) {
    if (n == 0)
        return 1;
    int bits = 0, tmp = n;
    while (tmp > 0) {
        bits++;
        tmp /= 2;
    }
    int mask = (1 << bits) - 1;
    int inv = (~n) & mask;
    int dec = 0, place = 1;
    if (inv == 0)
        return 0;
    while (bits--) {
        dec += (inv % 2) * place;
        inv /= 2;
        place *= 10;
    }
    return dec;
}

__global__ void borderComp(int *a, int *b, int rows, int cols) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= rows || j >= cols)
        return;
    int border = (i == 0 || j == 0 || i == rows - 1 || j == cols - 1);
    b[i * cols + j] = border ? a[i * cols + j] : onesCompDecimal(a[i * cols + j]);
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
    borderComp<<<blocks, threads>>>(d_a, d_b, rows, cols);
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
