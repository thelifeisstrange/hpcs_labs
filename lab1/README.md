# HPCS Lab 1 — Introduction to MPI

This lab introduces the core MPI workflow in C: starting an MPI program,
identifying a process by its rank, determining the number of active processes,
and assigning independent work to ranks.

Each question is a standalone program. The programs use the
single-program, multiple-data (SPMD) model: every MPI process executes the
same source file, then follows rank-dependent logic.

## Repository layout

```text
lab1/
├── q1/  # Process rank and world size
├── q2/  # Power of a constant by rank
├── q3/  # Rank-based parallel calculator
├── q4/  # Hello/World by rank parity
├── q5/  # Case toggling for characters in "HELLO"
└── q6/  # Factorial or Fibonacci by rank parity
```

Every directory contains:

- `sample.c` — C source code
- `sample.out` — a prebuilt executable for the machine on which it was built

Recompile the programs on your own machine or cluster; prebuilt executables
are platform-specific.

## Build and run

Run these commands from the directory for the question you want to execute.

```bash
cd q1
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

Question 2 uses `pow()` from the math library, so add `-lm` while linking:

```bash
cd q2
mpicc -o sample.out sample.c -lm
mpirun -np 4 ./sample.out
```

`mpiexec` may be used in place of `mpirun` on systems where it is the
preferred MPI launcher.

> MPI processes run concurrently, so the order of output lines can vary
> between executions.

## Exercises

### Q1 — Process rank and total process count

Each process obtains its rank and the size of `MPI_COMM_WORLD`, then prints
both values.

```bash
cd q1
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

Illustrative output:

```text
My rank is 0 out of 4 processes
My rank is 1 out of 4 processes
...
```

### Q2 — Calculate `x^rank`

Every process computes `pow(x, rank)` with the constant `x = 2.0`.
With four processes, ranks `0` through `3` compute `1`, `2`, `4`, and `8`.

```bash
cd q2
mpicc -o sample.out sample.c -lm
mpirun -np 4 ./sample.out
```

### Q3 — Parallel calculator

The program assigns one arithmetic operation to each of the first four ranks
using `a = 10` and `b = 5`.

| Rank | Operation | Result |
|---:|---|---:|
| 0 | `10 + 5` | 15 |
| 1 | `10 - 5` | 5 |
| 2 | `10 * 5` | 50 |
| 3 | `10 / 5` | 2 |

At least four processes are required. Ranks above `3` report that no
operation was assigned.

```bash
cd q3
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

### Q4 — Hello/World by rank parity

Even-ranked processes print `Hello`; odd-ranked processes print `World`.

```bash
cd q4
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

### Q5 — Toggle character case by rank

Each of the first five ranks works with the corresponding position in the
hard-coded string `HELLO`:

| Rank | Character toggled |
|---:|---|
| 0 | `H` → `h` |
| 1 | `E` → `e` |
| 2 | `L` → `l` |
| 3 | `L` → `l` |
| 4 | `O` → `o` |

Use at least five processes to cover every character. Each process has its
own local copy of the string, so the program reports individual character
changes rather than producing one shared final string.

```bash
cd q5
mpicc -o sample.out sample.c
mpirun -np 5 ./sample.out
```

### Q6 — Factorial or Fibonacci by rank parity

Even-ranked processes calculate the factorial of their rank; odd-ranked
processes calculate the Fibonacci number at their rank.

```bash
cd q6
mpicc -o sample.out sample.c
mpirun -np 6 ./sample.out
```

For example:

```text
Process 0: factorial(0) = 1
Process 1: fibonacci(1) = 1
Process 2: factorial(2) = 2
Process 3: fibonacci(3) = 2
```
