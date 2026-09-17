// Lab 7 Q2: S = PCAP  ->  RS = P + PC + PCA + PCAP  (prefixes concatenated).

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void prefixes(char *s, char *out, int n, int *starts) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n)
        return;
    int dest = starts[i];
    for (int k = 0; k <= i; k++)
        out[dest + k] = s[k];
}

int main() {
    char s[256];
    printf("Enter string S: ");
    scanf("%s", s);
    int n = (int)strlen(s);
    int total = n * (n + 1) / 2;
    int h_starts[256];
    int acc = 0;
    for (int i = 0; i < n; i++) {
        h_starts[i] = acc;
        acc += i + 1;
    }

    char h_out[1024];
    h_out[total] = '\0';
    char *d_s, *d_out;
    int *d_starts;
    cudaMalloc(&d_s, n);
    cudaMalloc(&d_out, total);
    cudaMalloc(&d_starts, n * sizeof(int));
    cudaMemcpy(d_s, s, n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_starts, h_starts, n * sizeof(int), cudaMemcpyHostToDevice);

    prefixes<<<1, n>>>(d_s, d_out, n, d_starts);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, total, cudaMemcpyDeviceToHost);
    h_out[total] = '\0';
    printf("RS: %s\n", h_out);

    cudaFree(d_s);
    cudaFree(d_out);
    cudaFree(d_starts);
    return 0;
}
