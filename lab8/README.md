# HPCS Lab 8 — CUDA programs on matrices

This lab uses CUDA kernels to add, multiply, and transform 2-D matrices on the GPU.

## Lab overview

- `q1/` — Matrix multiply `C = A x B` (`M x N` times `N x P`) with kernel and program timing
- `q2/` — Matrix add with three thread mappings:
  - `sample_a.cu` — one thread per row
  - `sample_b.cu` — one thread per column
  - `sample_c.cu` — one thread per element
- `q3/` — Transform an `N x N` matrix: diagonal → 0, above diagonal → factorial, below diagonal → sum of digits
- `q4/` — Matrix add and multiply using 2-D grids and 2-D blocks

## Build and run

These programs need NVIDIA CUDA (`nvcc`) and a GPU. This Mac does **not** have `nvcc`. Compile on a CUDA machine (lab PC / cluster):

```bash
nvcc sample.cu -o sample.out
./sample.out
```

Q1 example (`A` is 2x3, `B` is 3x2):

```bash
cd q1
nvcc sample.cu -o sample.out
echo "2 3 2  1 2 3  4 5 6  7 8  9 10  11 12" | ./sample.out
```

Expected `C`:

```text
58 64
139 154
```

Q2 example (2x2 add, any of a/b/c):

```bash
cd q2
nvcc sample_a.cu -o sample.out
echo "2 2  1 2  3 4  5 6  7 8" | ./sample.out
```

Expected `C`:

```text
6 8
10 12
```

Q3 example (`N = 3`):

```bash
cd q3
nvcc sample.cu -o sample.out
echo "3  1 4 3  12 5 2  15 20 7" | ./sample.out
```

Expected after transform:

```text
0  24  6
3   0  2
6   2  0
```

(`4! = 24`, `3! = 6`, `2! = 2`; digit sums of 12 and 15 and 20 are 3, 6, 2; diagonal becomes 0.)

Q4 example (`N = 2`):

```bash
cd q4
nvcc sample.cu -o sample.out
echo "2  1 2  3 4  5 6  7 8" | ./sample.out
```

Expected add:

```text
6 8
10 12
```

Expected multiply:

```text
19 22
43 50
```

## Question summary

### Q1 — Matrix multiply with timing

- Host reads `M N P`, then `A` (`M x N`) and `B` (`N x P`).
- One thread per element of `C`: `C[i][j] = sum_k A[i][k] * B[k][j]`.
- Kernel time uses CUDA events; program time uses `clock()`.

### Q2 — Matrix add, three mappings

- (a) Thread `i` walks row `i` and writes every `C[i][j]`.
- (b) Thread `j` walks column `j` and writes every `C[i][j]`.
- (c) Thread `idx` writes a single `C[idx]`.

### Q3 — Diagonal / factorial / digit-sum

- `i == j`: store `0`.
- `j > i` (above diagonal): store `A[i][j]!`.
- `i > j` (below diagonal): store the sum of decimal digits of `A[i][j]`.

### Q4 — 2-D grid and 2-D blocks

- `threadIdx.y` / `blockIdx.y` pick the row; `threadIdx.x` / `blockIdx.x` pick the column.
- Launch with `dim3 threads(16, 16)` and a 2-D grid large enough to cover `N x N`.
- Same layout is used for both add and multiply of two square matrices.

## Notes

- Always compile with `nvcc`. A normal `gcc` build will not understand `__global__` or `cudaMalloc`.
- Matrices are stored in row-major order: element `(i, j)` is at `i * cols + j`.
- Factorials in Q3 overflow a 32-bit `int` for values larger than 12; use small test numbers in the lab.
