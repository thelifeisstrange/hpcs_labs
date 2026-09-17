// q3) Write a CUDA program that takes a string S as input and one integer
// value N. Produces output string N times as follows in parallel:
// I/p: S = Hello    N = 3    O/p String: HelloHelloHello

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void repeatString(char *s, char *out, int len, int total) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < total)
        out[i] = s[i % len];
}

int main() {
    char h_s[1024];
    int n;

    printf("Enter string S: ");
    if (fgets(h_s, sizeof(h_s), stdin) == NULL)
        return 1;
    h_s[strcspn(h_s, "\n")] = '\0';

    printf("Enter N: ");
    if (scanf("%d", &n) != 1)
        return 1;

    int len = (int)strlen(h_s);
    if (len == 0 || n <= 0) {
        printf("Output: \n");
        return 0;
    }

    int total = len * n;
    char *h_out = (char *)malloc((total + 1) * sizeof(char));
    h_out[total] = '\0';

    char *d_s, *d_out;
    cudaMalloc(&d_s, len * sizeof(char));
    cudaMalloc(&d_out, total * sizeof(char));
    cudaMemcpy(d_s, h_s, len * sizeof(char), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (total + threads - 1) / threads;
    repeatString<<<blocks, threads>>>(d_s, d_out, len, total);
    cudaDeviceSynchronize();

    cudaMemcpy(h_out, d_out, total * sizeof(char), cudaMemcpyDeviceToHost);

    printf("Input S: %s\n", h_s);
    printf("N: %d\n", n);
    printf("Output: %s\n", h_out);

    cudaFree(d_s);
    cudaFree(d_out);
    free(h_out);
    return 0;
}
