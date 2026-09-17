# HPCS Lab 7 — CUDA programs on strings

This lab uses CUDA kernels to process character strings on the GPU.

## Lab overview

- `q1/` — Toggle case of every character in parallel, with kernel and program timing
- `q2/` — Reverse the ASCII value of each character in parallel
- `q3/` — Repeat string `S` exactly `N` times in parallel
- `q4/` — Reverse each word of a string in parallel

## Build and run

These programs need NVIDIA CUDA (`nvcc`) and a GPU. This Mac does **not** have `nvcc`. Compile on a CUDA machine (lab PC / cluster):

```bash
nvcc sample.cu -o sample.out
./sample.out
```

Example for Q1:

```bash
cd q1
nvcc sample.cu -o sample.out
echo "Hello" | ./sample.out
```

Expected toggled string: `hELLO`.

Q2 example (`Hello`):

```bash
cd q2
nvcc sample.cu -o sample.out
echo "Hello" | ./sample.out
```

Each character is replaced by the digit-reversal of its ASCII code (`H` = 72 → 27).

Q3 example (`Hello` repeated 3 times):

```bash
cd q3
nvcc sample.cu -o sample.out
printf "Hello\n3\n" | ./sample.out
```

Expected output: `HelloHelloHello`.

Q4 example:

```bash
cd q4
nvcc sample.cu -o sample.out
echo "one two three" | ./sample.out
```

Expected output: `eno owt eerht`.

## Question summary

### Q1 — Toggle case

- Host reads a string with `fgets`.
- Kernel `toggleChars` uses one thread per character: upper → lower, lower → upper.
- Result is stored in a second array.
- Kernel time uses CUDA events; program time uses `clock()`.

### Q2 — Reverse ASCII

- Each thread takes one character, reverses the decimal digits of its ASCII code, and writes that value into the output string.
- Example: `'A'` is 65, reversed digits give 56 (`'8'`).

### Q3 — Repeat string N times

- Output length is `len(S) * N`.
- Thread `i` writes `out[i] = S[i % len]`, so copies are built fully in parallel.

### Q4 — Reverse each word

- Host finds the start index and length of each word.
- Thread `w` reverses word `w` in place on the device.
- Spaces stay in the same positions.

## Notes

- Always compile with `nvcc`. A normal `gcc` build will not understand `__global__` or `cudaMalloc`.
- Copy data host → device before the kernel, then device → host after `cudaDeviceSynchronize()`.
- Use `fgets` (not `scanf("%s")`) so strings can contain spaces.
