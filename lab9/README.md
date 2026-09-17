# HPCS Lab 9 — CUDA sorting

This lab uses CUDA kernels to sort characters, words, and integer arrays on the GPU.

## Lab overview

- `q1/` — Sort a whole string with selection sort
- `q2/` — Sort each word of a string with selection sort (one thread per word)
- `q3/` — Odd-even transposition sort of N integers, using two kernels

## Build and run

These programs need NVIDIA CUDA (`nvcc`) and a GPU. This Mac does **not** have `nvcc`. Compile on a CUDA machine (lab PC / cluster):

```bash
nvcc sample.cu -o sample.out
./sample.out
```

Q1 example:

```bash
cd q1
nvcc sample.cu -o sample.out
echo "cuda" | ./sample.out
```

Expected: `acdu`.

Q2 example:

```bash
cd q2
nvcc sample.cu -o sample.out
echo "hello world cuda" | ./sample.out
```

Expected: `ehllo dlorw acdu`.

Q3 example:

```bash
cd q3
nvcc sample.cu -o sample.out
echo "6 5 1 4 2 8 3" | ./sample.out
```

Expected: `1 2 3 4 5 8`.

## Question summary

### Q1 — Selection sort a string

- Host reads a string with `fgets` and copies it to the device.
- Kernel `sortString` runs selection sort on the character array (smallest ASCII first).
- Spaces and punctuation are sorted along with letters.

### Q2 — Selection sort each word

- Host finds the start index and length of each word.
- Thread `w` runs selection sort only on word `w`.
- Spaces stay in the same positions; words are sorted independently in parallel.

### Q3 — Odd-even transposition sort (two kernels)

- `evenPhase`: compare-swap pairs `(0,1)`, `(2,3)`, `(4,5)`, …
- `oddPhase`: compare-swap pairs `(1,2)`, `(3,4)`, `(5,6)`, …
- Host launches even then odd, repeated `N` times, which is enough to fully sort `N` elements.

## Notes

- Always compile with `nvcc`. A normal `gcc` build will not understand `__global__` or `cudaMalloc`.
- Copy data host → device before the kernels, then device → host after `cudaDeviceSynchronize()`.
- Use `fgets` in Q1 and Q2 so the input can contain spaces.
