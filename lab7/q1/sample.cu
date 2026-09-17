// q1) Write a CUDA program which reads a string as input and it toggles
// every character of this string in parallel. Store the resultant string
// in another character array. Also find the execution time taken by
// kernel and the whole program.

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <cuda_runtime.h>

__global__ void toggleChars(char *in, char *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        char c = in[i];
        if (c >= 'A' && c <= 'Z')
            out[i] = c + 32;
        else if (c >= 'a' && c <= 'z')
            out[i] = c - 32;
        else
            out[i] = c;
    }
}

int main() {
    clock_t prog_start = clock();

    char h_in[1024];
    printf("Enter a string: ");
    if (fgets(h_in, sizeof(h_in), stdin) == NULL)
        return 1;
    h_in[strcspn(h_in, "\n")] = '\0';

    int n = (int)strlen(h_in);
    char h_out[1024];
    h_out[n] = '\0';

    char *d_in, *d_out;
    cudaMalloc(&d_in, n * sizeof(char));
    cudaMalloc(&d_out, n * sizeof(char));
    cudaMemcpy(d_in, h_in, n * sizeof(char), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n + threads - 1) / threads;

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    if (n > 0)
        toggleChars<<<blocks, threads>>>(d_in, d_out, n);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float kernel_ms = 0;
    cudaEventElapsedTime(&kernel_ms, start, stop);

    cudaMemcpy(h_out, d_out, n * sizeof(char), cudaMemcpyDeviceToHost);

    clock_t prog_end = clock();
    double prog_ms = 1000.0 * (double)(prog_end - prog_start) / CLOCKS_PER_SEC;

    printf("Input:  %s\n", h_in);
    printf("Toggled: %s\n", h_out);
    printf("Kernel time: %.6f ms\n", kernel_ms);
    printf("Program time: %.6f ms\n", prog_ms);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
