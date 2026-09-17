// Lab 8 Q2(b): Matrix multiply, one thread per result column.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void mulByCol(int *a, int *b, int *c, int m, int n, int p) {
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if (col >= p)
        return;
    for (int row = 0; row < m; row++) {
        int sum = 0;
        for (int k = 0; k < n; k++)
            sum += a[row * n + k] * b[k * p + col];
        c[row * p + col] = sum;
    }
}

int main() {
    int m, n, p;
    printf("Enter M N P: ");
    scanf("%d %d %d", &m, &n, &p);
    int *h_a = (int *)malloc(m * n * sizeof(int));
    int *h_b = (int *)malloc(n * p * sizeof(int));
    int *h_c = (int *)malloc(m * p * sizeof(int));
    printf("Enter A (%d x %d): ", m, n);
    for (int i = 0; i < m * n; i++)
        scanf("%d", &h_a[i]);
    printf("Enter B (%d x %d): ", n, p);
    for (int i = 0; i < n * p; i++)
        scanf("%d", &h_b[i]);

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, m * n * sizeof(int));
    cudaMalloc(&d_b, n * p * sizeof(int));
    cudaMalloc(&d_c, m * p * sizeof(int));
    cudaMemcpy(d_a, h_a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, n * p * sizeof(int), cudaMemcpyHostToDevice);
    mulByCol<<<(p + 255) / 256, 256>>>(d_a, d_b, d_c, m, n, p);
    cudaDeviceSynchronize();
    cudaMemcpy(h_c, d_c, m * p * sizeof(int), cudaMemcpyDeviceToHost);

    printf("C:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < p; j++)
            printf("%d ", h_c[i * p + j]);
        printf("\n");
    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
