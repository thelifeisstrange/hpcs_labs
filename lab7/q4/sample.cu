// q4) Write a CUDA program which reads a string consisting of N words
// and reverse each word of it in parallel.

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

#define MAX_WORDS 256

__global__ void reverseWords(char *s, int *start, int *len, int nwords) {
    int w = blockIdx.x * blockDim.x + threadIdx.x;
    if (w >= nwords)
        return;

    int st = start[w];
    int n = len[w];
    for (int j = 0; j < n / 2; j++) {
        char tmp = s[st + j];
        s[st + j] = s[st + n - 1 - j];
        s[st + n - 1 - j] = tmp;
    }
}

int main() {
    char h_s[1024];
    printf("Enter a string of words: ");
    if (fgets(h_s, sizeof(h_s), stdin) == NULL)
        return 1;
    h_s[strcspn(h_s, "\n")] = '\0';

    int n = (int)strlen(h_s);
    int h_start[MAX_WORDS];
    int h_len[MAX_WORDS];
    int nwords = 0;

    int i = 0;
    while (i < n && nwords < MAX_WORDS) {
        while (i < n && h_s[i] == ' ')
            i++;
        if (i >= n)
            break;
        h_start[nwords] = i;
        int wlen = 0;
        while (i < n && h_s[i] != ' ') {
            i++;
            wlen++;
        }
        h_len[nwords] = wlen;
        nwords++;
    }

    printf("Input:  %s\n", h_s);

    if (nwords == 0) {
        printf("Output: %s\n", h_s);
        return 0;
    }

    char *d_s;
    int *d_start, *d_len;
    cudaMalloc(&d_s, (n + 1) * sizeof(char));
    cudaMalloc(&d_start, nwords * sizeof(int));
    cudaMalloc(&d_len, nwords * sizeof(int));

    cudaMemcpy(d_s, h_s, (n + 1) * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_start, h_start, nwords * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_len, h_len, nwords * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (nwords + threads - 1) / threads;
    reverseWords<<<blocks, threads>>>(d_s, d_start, d_len, nwords);
    cudaDeviceSynchronize();

    cudaMemcpy(h_s, d_s, (n + 1) * sizeof(char), cudaMemcpyDeviceToHost);

    printf("Output: %s\n", h_s);
    printf("Words reversed: %d\n", nwords);

    cudaFree(d_s);
    cudaFree(d_start);
    cudaFree(d_len);
    return 0;
}
