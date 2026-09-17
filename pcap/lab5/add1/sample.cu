// Lab 5 additional: SAXPY  y = a*x + y

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void saxpy(float a, float *x, float *y, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        y[i] = a * x[i] + y[i];
}

int main() {
    int n;
    float a;
    printf("Enter N and scalar a: ");
    scanf("%d %f", &n, &a);
    int bytes = n * sizeof(float);
    float *h_x = (float *)malloc(bytes);
    float *h_y = (float *)malloc(bytes);
    printf("Enter %d elements of x: ", n);
    for (int i = 0; i < n; i++)
        scanf("%f", &h_x[i]);
    printf("Enter %d elements of y: ", n);
    for (int i = 0; i < n; i++)
        scanf("%f", &h_y[i]);

    float *d_x, *d_y;
    cudaMalloc(&d_x, bytes);
    cudaMalloc(&d_y, bytes);
    cudaMemcpy(d_x, h_x, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, h_y, bytes, cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    saxpy<<<blocks, threads>>>(a, d_x, d_y, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_y, d_y, bytes, cudaMemcpyDeviceToHost);

    printf("y = a*x + y: ");
    for (int i = 0; i < n; i++)
        printf("%.2f ", h_y[i]);
    printf("\n");

    cudaFree(d_x);
    cudaFree(d_y);
    free(h_x);
    free(h_y);
    return 0;
}
