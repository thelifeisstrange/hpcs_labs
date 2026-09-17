// q3) Write a CUDA program to read an integer array of N numbers.
// Sort this array using odd-even transposition sorting. (Use 2 kernels).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void evenPhase(int *a, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int left = 2 * i;
    if (left + 1 < n && a[left] > a[left + 1]) {
        int tmp = a[left];
        a[left] = a[left + 1];
        a[left + 1] = tmp;
    }
}

__global__ void oddPhase(int *a, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int left = 2 * i + 1;
    if (left + 1 < n && a[left] > a[left + 1]) {
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

    printf("Before: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_a[i]);
    printf("\n");

    int *d_a;
    cudaMalloc(&d_a, n * sizeof(int));
    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int evenPairs = n / 2;
    int oddPairs = (n - 1) / 2;
    int evenBlocks = (evenPairs + threads - 1) / threads;
    int oddBlocks = (oddPairs + threads - 1) / threads;

    for (int phase = 0; phase < n; phase++) {
        if (evenPairs > 0)
            evenPhase<<<evenBlocks, threads>>>(d_a, n);
        if (oddPairs > 0)
            oddPhase<<<oddBlocks, threads>>>(d_a, n);
    }
    cudaDeviceSynchronize();

    cudaMemcpy(h_a, d_a, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("After:  ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_a[i]);
    printf("\n");

    cudaFree(d_a);
    free(h_a);
    return 0;
}
