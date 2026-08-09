# HPCS Blocking Message Passing

This folder contains simple MPI programs that demonstrate different forms of blocking message passing in C.

## What is covered

Each example uses the single-program, multiple-data (SPMD) model, where every process runs the same program and follows rank-dependent logic.

### Examples in this folder

- `standard/` — basic blocking send and receive using `MPI_Send` and `MPI_Recv`
- `stdwithstatus/` — blocking send/receive with `MPI_Status` to inspect message details
- `syncsend/` — synchronous send using `MPI_Ssend`
- `bufferedsend/` — buffered send using `MPI_Bsend` with a user-managed buffer

## Build and run

Go to any example directory and compile it with:

```bash
mpicc -o sample.out sample.c
```

Then run it with two or more processes, for example:

```bash
mpirun -np 2 ./sample.out
```

## Program behavior

In each example:

- process 0 sends an integer value to process 1
- process 1 receives the value and prints it
- the program ends by finalizing MPI

## Notes

- The exact order of printed output may vary because MPI processes run concurrently.
- If your system uses `mpiexec` instead of `mpirun`, you can replace the launcher accordingly.
