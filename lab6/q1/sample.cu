// q1) Write a CUDA program to read two arrays A and B of same size N.
// Find the sum of corresponding array elements. Store the result in array C.

#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(int *a, int *b, int *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);

    int *h_a = (int *)malloc(n * sizeof(int));
    int *h_b = (int *)malloc(n * sizeof(int));
    int *h_c = (int *)malloc(n * sizeof(int));

    printf("Enter %d elements of A: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_a[i]);

    printf("Enter %d elements of B: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_b[i]);

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, n * sizeof(int));
    cudaMalloc(&d_b, n * sizeof(int));
    cudaMalloc(&d_c, n * sizeof(int));

    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, n * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    vectorAdd<<<blocks, threads>>>(d_a, d_b, d_c, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_c, d_c, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("A: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_a[i]);
    printf("\nB: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_b[i]);
    printf("\nC = A + B: ");
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
