# HPCS Lab 4 — MPI Advanced Collectives, Scans, and Timing

This lab explores advanced MPI collective operations including prefix scans (`MPI_Scan`), global reductions (`MPI_Reduce`), broad-spectrum scattering/gathering (`MPI_Scatter`, `MPI_Gather`), barrier synchronization (`MPI_Barrier`), and high-resolution wall-clock timing (`MPI_Wtime`).

## Lab Overview

Each question is implemented as a standalone C program in its own folder:

- `q1/` — Calculate $1! + 2! + \dots + N!$ using dual `MPI_Scan` (product for factorials, sum for prefix sum) and per-process execution timing.
- `q2/` — Search for a target key in a $3 \times 3$ matrix distributed row-wise across 3 processes, aggregating total occurrences using `MPI_Reduce`.
- `q3/` — Compute column-wise inclusive prefix sums across a $4 \times 4$ matrix using 4 processes with `MPI_Scatter`, `MPI_Scan`, and `MPI_Gather`.
- `q4/` — Transform an input word of length $N$ into a repeating character pattern (e.g. `PCAP` $\to$ `PCCAAAPPPP`) across $N$ processes using `MPI_Bcast`, variable local work, and gathered string reconstruction with execution timing.

## Build and Run

From each question directory, compile using `mpicc`:

```bash
mpicc -o sample.out sample.c
```

Run using `mpirun` with the required process count:

```bash
mpirun -np <number_of_processes> ./sample.out
```

### Examples

#### Q1: Factorial Series Prefix Sum ($1! + 2! + \dots + N!$)
```bash
cd q1
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

#### Q2: Matrix Element Search ($3 \times 3$ Matrix, 3 processes)
```bash
cd q2
mpicc -o sample.out sample.c
mpirun -np 3 ./sample.out
```

#### Q3: Matrix Column-wise Prefix Sum ($4 \times 4$ Matrix, 4 processes)
```bash
cd q3
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

#### Q4: Word Repetition Pattern ($N$ characters, $N$ processes)
```bash
cd q4
mpicc -o sample.out sample.c
mpirun -np 4 ./sample.out
```

## Question Summary

### Q1 — Factorial Prefix Sum & Performance Timing
- **Concepts**: `MPI_Scan` with `MPI_PROD`, `MPI_Scan` with `MPI_SUM`, `MPI_Wtime`, `MPI_Barrier`.
- Process $i$ (rank $i$) takes value $(i+1)$.
- First `MPI_Scan` with `MPI_PROD` produces $(i+1)!$.
- Second `MPI_Scan` with `MPI_SUM` accumulates $1! + 2! + \dots + (i+1)!$.
- Each process measures and reports its computation time, and root reports total wall-clock time.

### Q2 — Distributed Matrix Search
- **Concepts**: `MPI_Bcast`, `MPI_Scatter`, `MPI_Reduce` (`MPI_SUM`).
- Root reads a $3 \times 3$ matrix and a target search key.
- Key is broadcast to all 3 processes; rows are scattered so process $i$ searches row $i$.
- Local match counts are reduced to root using `MPI_SUM` to get the global frequency count.

### Q3 — Matrix Column Prefix Sum
- **Concepts**: `MPI_Scatter`, `MPI_Scan` (`MPI_SUM`), `MPI_Gather`.
- Root inputs a $4 \times 4$ integer matrix and scatters rows across 4 processes.
- Each process participates in `MPI_Scan` across the 4-element vectors, calculating cumulative column sums.
- Root gathers the scanned rows and displays the updated transformed matrix.

### Q4 — Rank-Proportional Character Expansion
- **Concepts**: `MPI_Bcast`, `MPI_Gather`, string manipulation, dynamic memory allocation.
- Root reads a word of length $N$ (must match process count $N$).
- Process $i$ takes character $i$ and duplicates it $(i+1)$ times.
- Resulting variable-length string fragments are gathered at root to assemble the final pattern.
- Both individual process times and total program runtimes are measured.

## Notes

- Ensure the number of MPI processes strictly matches program expectations (`np = 3` for Q2, `np = 4` for Q3, `np = strlen(word)` for Q4).
- `MPI_Wtime()` returns wall-clock time in seconds as a high-precision `double`.
