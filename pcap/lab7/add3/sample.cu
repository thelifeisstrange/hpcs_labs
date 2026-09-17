// Lab 7 additional: Hai -> Haaiii  (character i repeated i+1 times).

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void expand(char *s, char *out, int n, int *starts) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n)
        return;
    int times = i + 1;
    int dest = starts[i];
    for (int k = 0; k < times; k++)
        out[dest + k] = s[i];
}

int main() {
    char s[256];
    printf("Enter string Sin: ");
    scanf("%s", s);
    int n = (int)strlen(s);
    int h_starts[256];
    int total = 0;
    for (int i = 0; i < n; i++) {
        h_starts[i] = total;
        total += i + 1;
    }
    char h_out[1024];
    char *d_s, *d_out;
    int *d_starts;
    cudaMalloc(&d_s, n);
    cudaMalloc(&d_out, total);
    cudaMalloc(&d_starts, n * sizeof(int));
    cudaMemcpy(d_s, s, n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_starts, h_starts, n * sizeof(int), cudaMemcpyHostToDevice);
    expand<<<1, n>>>(d_s, d_out, n, d_starts);
    cudaDeviceSynchronize();
    cudaMemcpy(h_out, d_out, total, cudaMemcpyDeviceToHost);
    h_out[total] = '\0';
    printf("T: %s\n", h_out);

    cudaFree(d_s);
    cudaFree(d_out);
    cudaFree(d_starts);
    return 0;
}
