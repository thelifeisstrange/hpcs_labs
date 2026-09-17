// q3) Write a CUDA program which takes an integer array with N values
// and swaps alternative elements in that same array in parallel.

#include <stdio.h>
#include <cuda_runtime.h>

__global__ void swapAlternate(int *a, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int left = 2 * i;
    if (left + 1 < n) {
        int tmp = a[left];
        a[left] = a[left + 1];
        a[left + 1] = tmp;
    }
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);

    int *h_a = (int *)malloc(n * sizeof(int));

    printf("Enter %d elements: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_a[i]);

    printf("Before swap: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_a[i]);
    printf("\n");

    int *d_a;
    cudaMalloc(&d_a, n * sizeof(int));
    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);

    int pairs = n / 2;
    int threads = 256;
    int blocks = (pairs + threads - 1) / threads;
    if (pairs > 0)
        swapAlternate<<<blocks, threads>>>(d_a, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_a, d_a, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("After swap:  ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_a[i]);
    printf("\n");

    cudaFree(d_a);
    free(h_a);
    return 0;
}
