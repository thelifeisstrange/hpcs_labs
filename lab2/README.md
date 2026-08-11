# HPCS Lab 2 — MPI Communication and Parallel Processing

This folder contains a set of MPI programs that demonstrate message passing, data partitioning, and simple parallel computation in C.

## Programs in this lab

- `q1/` — Parallel calculator using different operations on different ranks
- `q2/` — Synchronous send/receive with message toggling between two processes
- `q3/` — Split an array into two halves and compute the sum in parallel
- `q4/` — Search for a target value in a partitioned array using two processes
- `q5/` — Split prime-number generation across two processes

## Build and run

Go to any question directory and compile the program with:

```bash
mpicc -o sample.out sample.c
```

Then run it with the required number of processes. For example:

```bash
mpirun -np 2 ./sample.out
```

Some programs require more than two processes, such as the calculator example, which needs at least four processes.

## Notes

- The exact order of printed output may vary because MPI processes run concurrently.
- If your system uses `mpiexec` instead of `mpirun`, you can use that launcher instead.
