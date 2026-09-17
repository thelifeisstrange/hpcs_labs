// Lab 9 additional: Repeat each char A[i][j] B[i][j] times into one string.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void expandChars(char *a, int *b, char *out, int *starts, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n)
        return;
    int dest = starts[i];
    for (int k = 0; k < b[i]; k++)
        out[dest + k] = a[i];
}

int main() {
    int rows, cols;
    printf("Enter rows cols: ");
    scanf("%d %d", &rows, &cols);
    int n = rows * cols;
    char *h_a = (char *)malloc(n);
    int *h_b = (int *)malloc(n * sizeof(int));
    printf("Enter %d characters of A: ", n);
    for (int i = 0; i < n; i++)
        scanf(" %c", &h_a[i]);
    printf("Enter %d integers of B: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_b[i]);

    int *h_starts = (int *)malloc(n * sizeof(int));
    int total = 0;
    for (int i = 0; i < n; i++) {
        h_starts[i] = total;
        total += h_b[i];
    }
    char *h_out = (char *)malloc(total + 1);

    char *d_a, *d_out;
    int *d_b, *d_starts;
    cudaMalloc(&d_a, n);
    cudaMalloc(&d_b, n * sizeof(int));
    cudaMalloc(&d_starts, n * sizeof(int));
    cudaMalloc(&d_out, total);
    cudaMemcpy(d_a, h_a, n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_starts, h_starts, n * sizeof(int), cudaMemcpyHostToDevice);

    expandChars<<<(n + 255) / 256, 256>>>(d_a, d_b, d_out, d_starts, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, total, cudaMemcpyDeviceToHost);
    h_out[total] = '\0';
    printf("STR: %s\n", h_out);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_starts);
    cudaFree(d_out);
    free(h_a);
    free(h_b);
    free(h_starts);
    free(h_out);
    return 0;
}
