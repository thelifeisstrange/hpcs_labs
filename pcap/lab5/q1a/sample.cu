// Lab 5 Q1(a): Add two vectors of length N using block size N (1 block, N threads).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void add(int *a, int *b, int *c, int n) {
    int i = threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);
    int bytes = n * sizeof(int);
    int *h_a = (int *)malloc(bytes);
    int *h_b = (int *)malloc(bytes);
    int *h_c = (int *)malloc(bytes);
    printf("Enter %d elements of A: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_a[i]);
    printf("Enter %d elements of B: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_b[i]);

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    add<<<1, n>>>(d_a, d_b, d_c, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    printf("C: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_c[i]);
    printf("\n");

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}
