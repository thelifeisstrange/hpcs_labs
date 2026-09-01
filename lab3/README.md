# HPCS Lab 3 — MPI Collective Communication

This lab focuses on MPI collective communication techniques such as `MPI_Bcast`, `MPI_Scatter`, and `MPI_Gather`.

## Lab overview

Each question is implemented as a separate C program in its own folder:

- `q1/` — Factorial of values distributed one per process
- `q2/` — Average of blocks of numbers and total average
- `q3/` — Interleave two strings chunk-wise across processes
- `q4/` — Raise numbers to powers based on process rank and collect results

## Build and run

From each question directory, compile the program using:

```bash
mpicc -o sample.out sample.c
```

Then run it with the required number of processes:

```bash
mpirun -np <number_of_processes> ./sample.out
```

For example:

```bash
cd q1
mpicc -o sample.out sample.c
mpirun -np 3 ./sample.out
```

## Question summary

### Q1 — Factorial distribution

- Root process reads `N` values.
- One value is sent to each process using `MPI_Scatter`.
- Every process computes the factorial of its value.
- Root gathers the results and prints them.

### Q2 — Average calculation

- Root reads `M` and `N`.
- It distributes `M` elements to each process using `MPI_Scatter`.
- Each process computes the average of the received elements.
- Root gathers all local averages and computes the global average.

### Q3 — String interleaving

- Root reads two strings of equal length.
- The strings are divided into chunks and scattered to processes.
- Each process interleaves the corresponding chunk from both strings.
- Root gathers the partial results and displays the final combined string.

### Q4 — Power computation

- Root reads `M` and the total number of values.
- The values are distributed among processes using `MPI_Scatter`.
- Each process raises its assigned numbers to a power depending on its rank.
- Root gathers all results and prints the final output.

## Notes

- The exact order of printed output may vary because MPI processes run concurrently.
- If your system uses `mpiexec` instead of `mpirun`, replace it accordingly.
