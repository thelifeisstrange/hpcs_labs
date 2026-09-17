// q2) Write a CUDA program which reads a string as input and produces
// resultant string which is having characters obtained by reversing ASCII
// value of corresponding character in the original string.

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__device__ unsigned char reverseAscii(unsigned char c) {
    int num = c;
    int rev = 0;
    while (num > 0) {
        rev = rev * 10 + num % 10;
        num /= 10;
    }
    return (unsigned char)rev;
}

__global__ void reverseAsciiChars(char *in, char *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        out[i] = (char)reverseAscii((unsigned char)in[i]);
}

int main() {
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
    if (n > 0)
        reverseAsciiChars<<<blocks, threads>>>(d_in, d_out, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_out, d_out, n * sizeof(char), cudaMemcpyDeviceToHost);

    printf("Input:  %s\n", h_in);
    printf("Output: %s\n", h_out);
    printf("ASCII in -> reversed ASCII:\n");
    for (int i = 0; i < n; i++) {
        int orig = (unsigned char)h_in[i];
        int num = orig;
        int rev = 0;
        while (num > 0) {
            rev = rev * 10 + num % 10;
            num /= 10;
        }
        printf("  '%c' (%d) -> %d", h_in[i], orig, rev);
        if (rev >= 32 && rev <= 126)
            printf(" ('%c')", (char)rev);
        printf("\n");
    }

    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
