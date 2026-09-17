// q2) Write a CUDA program which takes N decimal values as input.
// Convert them to octal in parallel and store the result in another array.

#include <stdio.h>
#include <cuda_runtime.h>

__device__ int decimalToOctal(int n) {
    int octal = 0;
    int place = 1;
    if (n < 0)
        n = -n;
    while (n > 0) {
        octal += (n % 8) * place;
        n /= 8;
        place *= 10;
    }
    return octal;
}

__global__ void toOctal(int *dec, int *oct, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        oct[i] = decimalToOctal(dec[i]);
}

int main() {
    int n;
    printf("Enter N: ");
    scanf("%d", &n);

    int *h_dec = (int *)malloc(n * sizeof(int));
    int *h_oct = (int *)malloc(n * sizeof(int));

    printf("Enter %d decimal values: ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h_dec[i]);

    int *d_dec, *d_oct;
    cudaMalloc(&d_dec, n * sizeof(int));
    cudaMalloc(&d_oct, n * sizeof(int));
    cudaMemcpy(d_dec, h_dec, n * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    toOctal<<<blocks, threads>>>(d_dec, d_oct, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_oct, d_oct, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Decimal: ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_dec[i]);
    printf("\nOctal:    ");
    for (int i = 0; i < n; i++)
        printf("%d ", h_oct[i]);
    printf("\n");

    cudaFree(d_dec);
    cudaFree(d_oct);
    free(h_dec);
    free(h_oct);
    return 0;
}
