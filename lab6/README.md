# HPCS Lab 6 — CUDA programs on vectors

This lab uses CUDA kernels to process 1-D arrays on the GPU.

## Lab overview

- `q1/` — Element-wise sum of two arrays `A` and `B` into `C`
- `q2/` — Convert N decimal values to octal in parallel
- `q3/` — Swap alternate elements of an array in place

## Build and run

These programs need NVIDIA CUDA (`nvcc`) and a GPU. This Mac does **not** have `nvcc`. Compile on a CUDA machine (lab PC / cluster):

```bash
nvcc sample.cu -o sample.out
./sample.out
```

Example for Q1 with N = 4:

```bash
cd q1
nvcc sample.cu -o sample.out
echo "4 1 2 3 4 10 20 30 40" | ./sample.out
```

Expected: `C = 11 22 33 44`.

Q2 example (decimals `8 10 15`):

```bash
cd q2
nvcc sample.cu -o sample.out
echo "3 8 10 15" | ./sample.out
```

Expected octal values stored as integers: `10 12 17`.

Q3 example (swap pairs in `1 2 3 4 5`):

```bash
cd q3
nvcc sample.cu -o sample.out
echo "5 1 2 3 4 5" | ./sample.out
```

Expected after swap: `2 1 4 3 5` (last element stays if N is odd).

## Question summary

### Q1 — Vector add

- Host reads `N`, then arrays `A` and `B`.
- Kernel `vectorAdd` uses one thread per index: `C[i] = A[i] + B[i]`.
- Grid size is `(N + 255) / 256` blocks of 256 threads.

### Q2 — Decimal to octal

- Each thread converts one decimal number by repeated `% 8` / `/ 8`.
- The octal digits are stored as a base-10 integer (for example 10 decimal → 12).

### Q3 — Swap alternate elements

- Thread `i` swaps `a[2*i]` with `a[2*i+1]` in the same device array.
- Launch `N/2` threads so pairs do not overlap.

## Notes

- Always compile with `nvcc`. A normal `gcc` build will not understand `__global__` or `cudaMalloc`.
- Copy data host → device before the kernel, then device → host after `cudaDeviceSynchronize()`.
