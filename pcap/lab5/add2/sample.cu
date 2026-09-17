// Lab 5 additional / Lab 6 Q2: Selection-sort every row of a matrix in parallel.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void sortRows(int *a, int rows, int cols) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    if (r >= rows)
        return;
    int *row = a + r * cols;
    for (int i = 0; i < cols - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < cols; j++)
            if (row[j] < row[minIdx])
                minIdx = j;
        int tmp = row[i];
        row[i] = row[minIdx];
        row[minIdx] = tmp;
    }
}

int main() {
    int rows, cols;
    printf("Enter rows cols: ");
    scanf("%d %d", &rows, &cols);
    int n = rows * cols;
    int *h = (int *)malloc(n * sizeof(int));
    printf("Enter %d elements (row-major): ", n);
    for (int i = 0; i < n; i++)
        scanf("%d", &h[i]);

    int *d;
    cudaMalloc(&d, n * sizeof(int));
    cudaMemcpy(d, h, n * sizeof(int), cudaMemcpyHostToDevice);
    sortRows<<<(rows + 255) / 256, 256>>>(d, rows, cols);
    cudaDeviceSynchronize();
    cudaMemcpy(h, d, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Sorted rows:\n");
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++)
            printf("%d ", h[i * cols + j]);
        printf("\n");
    }
    cudaFree(d);
    free(h);
    return 0;
}
