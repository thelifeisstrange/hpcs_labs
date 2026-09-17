// Lab 9 Q1: Sparse matrix-vector multiply using CSR.

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void spmv(int *data, int *col, int *rowPtr, int *x, int *y, int rows) {
    int r = blockIdx.x * blockDim.x + threadIdx.x;
    if (r >= rows)
        return;
    int sum = 0;
    for (int k = rowPtr[r]; k < rowPtr[r + 1]; k++)
        sum += data[k] * x[col[k]];
    y[r] = sum;
}

int main() {
    int rows, nnz, cols;
    printf("Enter rows, cols, nnz: ");
    scanf("%d %d %d", &rows, &cols, &nnz);
    int *h_data = (int *)malloc(nnz * sizeof(int));
    int *h_col = (int *)malloc(nnz * sizeof(int));
    int *h_row = (int *)malloc((rows + 1) * sizeof(int));
    int *h_x = (int *)malloc(cols * sizeof(int));
    int *h_y = (int *)malloc(rows * sizeof(int));

    printf("Enter CSR data[%d]: ", nnz);
    for (int i = 0; i < nnz; i++)
        scanf("%d", &h_data[i]);
    printf("Enter col_index[%d]: ", nnz);
    for (int i = 0; i < nnz; i++)
        scanf("%d", &h_col[i]);
    printf("Enter row_ptr[%d]: ", rows + 1);
    for (int i = 0; i <= rows; i++)
        scanf("%d", &h_row[i]);
    printf("Enter vector x[%d]: ", cols);
    for (int i = 0; i < cols; i++)
        scanf("%d", &h_x[i]);

    int *d_data, *d_col, *d_row, *d_x, *d_y;
    cudaMalloc(&d_data, nnz * sizeof(int));
    cudaMalloc(&d_col, nnz * sizeof(int));
    cudaMalloc(&d_row, (rows + 1) * sizeof(int));
    cudaMalloc(&d_x, cols * sizeof(int));
    cudaMalloc(&d_y, rows * sizeof(int));
    cudaMemcpy(d_data, h_data, nnz * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col, h_col, nnz * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_row, h_row, (rows + 1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, h_x, cols * sizeof(int), cudaMemcpyHostToDevice);

    spmv<<<(rows + 255) / 256, 256>>>(d_data, d_col, d_row, d_x, d_y, rows);
    cudaDeviceSynchronize();
    cudaMemcpy(h_y, d_y, rows * sizeof(int), cudaMemcpyDeviceToHost);

    printf("y: ");
    for (int i = 0; i < rows; i++)
        printf("%d ", h_y[i]);
    printf("\n");

    cudaFree(d_data);
    cudaFree(d_col);
    cudaFree(d_row);
    cudaFree(d_x);
    cudaFree(d_y);
    free(h_data);
    free(h_col);
    free(h_row);
    free(h_x);
    free(h_y);
    return 0;
}
