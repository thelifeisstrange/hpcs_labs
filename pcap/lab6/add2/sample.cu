// Lab 6 additional: One's complement of N binary numbers (0/1 bits stored as ints).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void onesComplement(int *in, int *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        out[i] = in[i] ? 0 : 1;
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);
    int *h_in = (int *)malloc(n * sizeof(int));
    int *h_out = (int *)malloc(n * sizeof(int));
    printf("Enter %d binary digits (0/1): ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_in[i]);

    int *d_in, *d_out;
    cudaMalloc(&d_in, n * sizeof(int));
    cudaMalloc(&d_out, n * sizeof(int));
    cudaMemcpy(d_in, h_in, n * sizeof(int), cudaMemcpyHostToDevice);
    int threads = 256;
    onesComplement<<<(n + threads - 1) / threads, threads>>>(d_in, d_out, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("1's complement: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_out[i]);
    printf("\n");

    cudaFree(d_in);
    cudaFree(d_out);
    free(h_in);
    free(h_out);
    return 0;
}
