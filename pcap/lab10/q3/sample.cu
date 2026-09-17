// Lab 10 Q3: Inclusive scan (prefix sum) of an integer array.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void inclusiveScan(int *a, int *out, int n) {
    int i = threadIdx.x;
    if (i >= n)
        return;
    extern __shared__ int temp[];
    temp[i] = a[i];
    __syncthreads();
    for (int offset = 1; offset < n; offset *= 2) {
        int val = temp[i];
        if (i >= offset)
            val += temp[i - offset];
        __syncthreads();
        temp[i] = val;
        __syncthreads();
    }
    out[i] = temp[i];
}

int main() {
    int n;
    printf("Enter N (N <= 1024): ");
    scanf("%d", &n);
    int *h_a = (int *)malloc(n * sizeof(int));
    int *h_out = (int *)malloc(n * sizeof(int));
    printf("Enter %d elements: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_a[i]);

    int *d_a, *d_out;
    cudaMalloc(&d_a, n * sizeof(int));
    cudaMalloc(&d_out, n * sizeof(int));
    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);
    inclusiveScan<<<1, n, n * sizeof(int)>>>(d_a, d_out, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Inclusive scan: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_out[i]);
    printf("\n");

    cudaFree(d_a);
    cudaFree(d_out);
    free(h_a);
    free(h_out);
    return 0;
}
