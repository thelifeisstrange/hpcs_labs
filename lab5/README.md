# HPCS Lab 5 — OpenMP

This lab uses OpenMP for shared-memory parallelism in C.

## Lab overview

Each question is a separate C program in its own folder:

- `HelloWorld/` — Hello World from each OpenMP thread
- `q1/` — Shared vs private variables
- `q2/` — Element-wise sum of two arrays (cores vs extra threads)
- `q3/` — Sum of integers 1 to N (parallel for vs reduction)
- `q4/` — Nested `for` loops with `collapse(2)` (2-D matrix add)
- `q5/` — Sum of first 100 integers with parallel for
- `q6/` — Maximum element of an array
- `q7/` — Factorial of different numbers, one per thread
- `q8/` — Safe increment counter using OpenMP locks

## macOS OpenMP configuration

This Mac does **not** use system `gcc` for OpenMP.

| Tool | Path / version | Role |
| --- | --- | --- |
| Apple `gcc` | `/usr/bin/gcc` (Clang wrapper) | Default `gcc` command. **Does not support** `-fopenmp`. |
| Homebrew GCC | `gcc-16` (`/opt/homebrew/bin/gcc-16`) | Real GCC. Use this to compile OpenMP programs. |
| Homebrew libomp | `/opt/homebrew/opt/libomp` | OpenMP runtime and `omp.h` (used by Clang if needed). |

Installed with Homebrew:

```bash
brew install gcc
brew install libomp
```

### Why `gcc -fopenmp` fails

On macOS, `gcc` is Apple Clang:

```text
clang: error: unsupported option '-fopenmp'
```

Use Homebrew GCC instead of Apple `gcc`.

## Build and run

From a question directory:

```bash
gcc-16 -fopenmp sample.c -o sample.out
./sample.out
```

Example for Q1:

```bash
cd q1
gcc-16 -fopenmp sample.c -o sample.out
./sample.out
```

Q4 is the same from `q4/`. Q3 needs `N` on stdin, for example:

```bash
cd q3
gcc-16 -fopenmp sample2.c -o sample.out
echo 10 | ./sample.out
```

Optional: set the number of threads (default is all CPU cores):

```bash
OMP_NUM_THREADS=4 ./sample.out
```

### Alternate compile (Apple Clang + libomp)

Only needed if you cannot use `gcc-16`:

```bash
clang -Xpreprocessor -fopenmp \
  -I/opt/homebrew/opt/libomp/include \
  -L/opt/homebrew/opt/libomp/lib \
  -lomp sample.c -o sample.out
```

## Optional shell shortcut

Add this to `~/.zshrc` so you do not type `gcc-16 -fopenmp` every time:

```bash
alias ompcc='gcc-16 -fopenmp'
```

Then open a new terminal and run:

```bash
ompcc sample.c -o sample.out
./sample.out
```

## Question summary

### Hello World

- Uses `#pragma omp parallel` so each thread runs the same block.
- Each thread prints `Hello World` with its thread id and the total thread count.
- Thread print order can change between runs.

### Q1 — Shared vs private

- `shared(shared_var)`: all threads update one copy; the value after the region is changed.
- `private(private_var)`: each thread has its own copy; the original stays 10 after the region.

### Q2 — Array element-wise sum

- `q2/sample1.c` — `parallel for` with the default thread count (CPU cores).
- `q2/sample2.c` — `parallel for num_threads(24)` regardless of core count.

### Q3 — Sum 1 to N

- `q3/sample1.c` — `parallel for` plus `critical` (no reduction).
- `q3/sample2.c` — `parallel for reduction(+:sum)`.
- Both programs read `N` from stdin.

### Q4 — Nested for loops

- Adds two 4×4 matrices.
- `#pragma omp parallel for collapse(2)` splits the nested `i`/`j` loops across threads.
- Prints which thread computed each `C[i][j]`.

### Q5 — Sum of first 100 integers

- `#pragma omp parallel for reduction(+:sum)` adds 1 through 100.
- Prints the computed sum and the closed-form `n*(n+1)/2`.

### Q6 — Maximum of an array

- `#pragma omp parallel for reduction(max:max_val)` finds the largest element.
- Works on a fixed sample array of 12 integers.

### Q7 — Parallel factorials

- Four threads; thread `tid` computes `nums[tid]!`.
- Each thread prints its number and factorial.

### Q8 — Locked increment counter

- `omp_init_lock` / `omp_set_lock` / `omp_unset_lock` protect `counter++`.
- Four threads each increment 100000 times; final value should match 400000.

## Notes

- Always compile with `-fopenmp`. Without it, `omp.h` is missing or the parallel region runs as a single thread.
- Do not use `gcc -fopenmp` on this machine. Use `gcc-16 -fopenmp`.
