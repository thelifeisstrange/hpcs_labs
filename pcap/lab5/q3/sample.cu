// Lab 5 Q3: Sine of each angle in a 1-D array (angles in radians).

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void sineKernel(float *in, float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        out[i] = sinf(in[i]);
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);
    int bytes = n * sizeof(float);
    float *h_in = (float *)malloc(bytes);
    float *h_out = (float *)malloc(bytes);
    printf("Enter %d angles in radians: ", n);
    for (int i = 0; i < n; i++)
        scanf("%f", &h_in[i]);

    float *d_in, *d_out;
    cudaMalloc(&d_in, bytes);
    cudaMalloc(&d_out, bytes);
    cudaMemcpy(d_in, h_in, bytes, cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    sineKernel<<<blocks, threads>>>(d_in, d_out, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, bytes, cudaMemcpyDeviceToHost);

    printf("sin: ");
    for (int i = 0; i < n; i++)
        printf("%.4f ", h_out[i]);
    printf("\n");

    cudaFree(d_in);
    cudaFree(d_out);
    free(h_in);
    free(h_out);
    return 0;
}
