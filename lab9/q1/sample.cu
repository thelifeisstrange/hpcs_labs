// q1) Write a program in CUDA to sort a given string using selection sort.

#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__device__ void selectionSort(char *a, int n) {
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) {
            if (a[j] < a[minIdx])
                minIdx = j;
        }
        char tmp = a[i];
        a[i] = a[minIdx];
        a[minIdx] = tmp;
    }
}

__global__ void sortString(char *a, int n) {
    if (blockIdx.x == 0 && threadIdx.x == 0)
        selectionSort(a, n);
}

int main() {
    char h_s[1024];
    printf("Enter a string: ");
    if (fgets(h_s, sizeof(h_s), stdin) == NULL)
        return 1;
    h_s[strcspn(h_s, "\n")] = '\0';

    int n = (int)strlen(h_s);
    printf("Before: %s\n", h_s);

    char *d_s;
    cudaMalloc(&d_s, (n + 1) * sizeof(char));
    cudaMemcpy(d_s, h_s, (n + 1) * sizeof(char), cudaMemcpyHostToDevice);

    sortString<<<1, 1>>>(d_s, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_s, d_s, (n + 1) * sizeof(char), cudaMemcpyDeviceToHost);

    printf("After:  %s\n", h_s);

    cudaFree(d_s);
    return 0;
}
