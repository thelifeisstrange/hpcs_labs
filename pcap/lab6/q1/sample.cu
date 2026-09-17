// Lab 6 Q1: 1-D convolution of array N with mask M.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void conv1d(float *N, float *M, float *P, int maskWidth, int width) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= width)
        return;
    float p = 0;
    int start = i - maskWidth / 2;
    for (int j = 0; j < maskWidth; j++) {
        int idx = start + j;
        if (idx >= 0 && idx < width)
            p += N[idx] * M[j];
    }
    P[i] = p;
}

int main() {
    int width, maskWidth;
    printf("Enter width of N: ");
    scanf("%d", &width);
    printf("Enter mask width (odd): ");
    scanf("%d", &maskWidth);

    float *h_n = (float *)malloc(width * sizeof(float));
    float *h_m = (float *)malloc(maskWidth * sizeof(float));
    float *h_p = (float *)malloc(width * sizeof(float));
    printf("Enter N: ");
    for (int i = 0; i < width; i++)
        scanf("%f", &h_n[i]);
    printf("Enter mask M: ");
    for (int i = 0; i < maskWidth; i++)
        scanf("%f", &h_m[i]);

    float *d_n, *d_m, *d_p;
    cudaMalloc(&d_n, width * sizeof(float));
    cudaMalloc(&d_m, maskWidth * sizeof(float));
    cudaMalloc(&d_p, width * sizeof(float));
    cudaMemcpy(d_n, h_n, width * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_m, h_m, maskWidth * sizeof(float), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (width + threads - 1) / threads;
    conv1d<<<blocks, threads>>>(d_n, d_m, d_p, maskWidth, width);
    cudaDeviceSynchronize();
    cudaMemcpy(h_p, d_p, width * sizeof(float), cudaMemcpyDeviceToHost);

    printf("P: ");
    for (int i = 0; i < width; i++)
        printf("%.1f ", h_p[i]);
    printf("\n");

    cudaFree(d_n);
    cudaFree(d_m);
    cudaFree(d_p);
    free(h_n);
    free(h_m);
    free(h_p);
    return 0;
}
