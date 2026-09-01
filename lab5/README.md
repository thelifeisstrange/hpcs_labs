# HPCS Lab 5 — OpenMP

This lab uses OpenMP for shared-memory parallelism in C.

## Lab overview

Each question is a separate C program in its own folder:

- `q1/` — Hello World from each OpenMP thread

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

### Q1 — Hello World

- Uses `#pragma omp parallel` so each thread runs the same block.
- Each thread prints `Hello World` with its thread id and the total thread count.
- Thread print order can change between runs.

## Notes

- Always compile with `-fopenmp`. Without it, `omp.h` is missing or the parallel region runs as a single thread.
- Do not use `gcc -fopenmp` on this machine. Use `gcc-16 -fopenmp`.
