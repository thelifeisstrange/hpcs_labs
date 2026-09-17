// Lab 7 Q1: Count how many times a given word appears in a sentence (atomicAdd).

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void countWord(char *s, int n, char *word, int wlen, int *count) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i + wlen > n)
        return;
    if (i > 0 && s[i - 1] != ' ')
        return;
    int match = 1;
    for (int k = 0; k < wlen; k++) {
        if (s[i + k] != word[k]) {
            match = 0;
            break;
        }
    }
    if (match && (i + wlen == n || s[i + wlen] == ' '))
        atomicAdd(count, 1);
}

int main() {
    char s[1024], word[128];
    printf("Enter a sentence: ");
    if (fgets(s, sizeof(s), stdin) == NULL)
        return 1;
    s[strcspn(s, "\n")] = '\0';
    printf("Enter the word: ");
    scanf("%s", word);

    int n = (int)strlen(s);
    int wlen = (int)strlen(word);
    int h_count = 0;
    char *d_s, *d_w;
    int *d_count;
    cudaMalloc(&d_s, n * sizeof(char));
    cudaMalloc(&d_w, wlen * sizeof(char));
    cudaMalloc(&d_count, sizeof(int));
    cudaMemcpy(d_s, s, n * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_w, word, wlen * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &h_count, sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    countWord<<<(n + threads - 1) / threads, threads>>>(d_s, n, d_w, wlen, d_count);
    cudaDeviceSynchronize();
    cudaMemcpy(&h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);
    printf("Count of '%s' = %d\n", word, h_count);

    cudaFree(d_s);
    cudaFree(d_w);
    cudaFree(d_count);
    return 0;
}
