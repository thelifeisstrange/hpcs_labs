// Lab 10 Q2: 1-D convolution using constant memory for the mask.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__constant__ float d_mask[64];

__global__ void convConst(float *N, float *P, int maskWidth, int width) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= width)
        return;
    float p = 0;
    int start = i - maskWidth / 2;
    for (int j = 0; j < maskWidth; j++) {
        int idx = start + j;
        if (idx >= 0 && idx < width)
            p += N[idx] * d_mask[j];
    }
    P[i] = p;
}

int main() {
    int width, maskWidth;
    printf("Enter width of N: ");
    scanf("%d", &width);
    printf("Enter mask width (odd, <= 64): ");
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

    float *d_n, *d_p;
    cudaMalloc(&d_n, width * sizeof(float));
    cudaMalloc(&d_p, width * sizeof(float));
    cudaMemcpy(d_n, h_n, width * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpyToSymbol(d_mask, h_m, maskWidth * sizeof(float));

    int threads = 256;
    convConst<<<(width + threads - 1) / threads, threads>>>(d_n, d_p, maskWidth, width);
    cudaDeviceSynchronize();
    cudaMemcpy(h_p, d_p, width * sizeof(float), cudaMemcpyDeviceToHost);

    printf("P: ");
    for (int i = 0; i < width; i++)
        printf("%.1f ", h_p[i]);
    printf("\n");

    cudaFree(d_n);
    cudaFree(d_p);
    free(h_n);
    free(h_m);
    free(h_p);
    return 0;
}
