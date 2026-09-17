// Lab 6 Q2: Selection sort an integer array in parallel (ranking).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void selectionRank(int *in, int *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n)
        return;
    int pos = 0;
    for (int j = 0; j < n; j++)
        if (in[j] < in[i] || (in[j] == in[i] && j < i))
            pos++;
    out[pos] = in[i];
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);
    int *h_in = (int *)malloc(n * sizeof(int));
    int *h_out = (int *)malloc(n * sizeof(int));
    printf("Enter %d elements: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_in[i]);

    int *d_in, *d_out;
    cudaMalloc(&d_in, n * sizeof(int));
    cudaMalloc(&d_out, n * sizeof(int));
    cudaMemcpy(d_in, h_in, n * sizeof(int), cudaMemcpyHostToDevice);
    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    selectionRank<<<blocks, threads>>>(d_in, d_out, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Sorted: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_out[i]);
    printf("\n");

    cudaFree(d_in);
    cudaFree(d_out);
    free(h_in);
    free(h_out);
    return 0;
}
