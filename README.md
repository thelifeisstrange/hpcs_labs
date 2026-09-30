# High Performance Computing Systems (HPCS)

Comprehensive laboratory coursework, implementations, and reference code for **High Performance Computing Systems (HPCS)** / **Parallel and Concurrent Applications Programming (PCAP)**.

This repository covers the three dominant paradigms in modern high-performance parallel computing:
1. **Distributed Memory Parallelism** with **Message Passing Interface (MPI)** in C.
2. **Shared Memory Multi-threading** with **OpenMP** in C.
3. **Many-Core Accelerator Computing (SIMT / GPGPU)** with **NVIDIA CUDA** in C/C++.

---

## Table of Contents

- [Repository Architecture](#repository-architecture)
- [Computing Paradigms Comparison](#computing-paradigms-comparison)
- [Module Index & Lab Descriptions](#module-index--lab-descriptions)
  - [1. `mpi_intro/` — Introduction to MPI (Lab 1)](#1-mpi_intro--introduction-to-mpi-lab-1)
  - [2. `blockingmsgpassing/` — Point-to-Point Blocking Communication](#2-blockingmsgpassing--point-to-point-blocking-communication)
  - [3. `lab2/` — Data Partitioning & Synchronous Communication (Lab 2)](#3-lab2--data-partitioning--synchronous-communication-lab-2)
  - [4. `lab3/` — Collective Communication: Broadcast, Scatter & Gather (Lab 3)](#4-lab3--collective-communication-broadcast-scatter--gather-lab-3)
  - [5. `lab4/` — Advanced Collectives: Scans, Reductions & Timing (Lab 4)](#5-lab4--advanced-collectives-scans-reductions--timing-lab-4)
  - [6. `lab5/` — Shared-Memory Multi-Threading with OpenMP (Lab 5)](#6-lab5--shared-memory-multi-threading-with-openmp-lab-5)
  - [7. `lab6/` — GPU Computing with CUDA: Vectors & Memory Transfers (Lab 6)](#7-lab6--gpu-computing-with-cuda-vectors--memory-transfers-lab-6)
  - [8. `lab7/` — GPU Computing with CUDA: Parallel String Processing (Lab 7)](#8-lab7--gpu-computing-with-cuda-parallel-string-processing-lab-7)
  - [9. `lab8/` — GPU Computing with CUDA: 2-D Matrices & Thread Mapping (Lab 8)](#9-lab8--gpu-computing-with-cuda-2-d-matrices--thread-mapping-lab-8)
  - [10. `lab9/` — GPU Computing with CUDA: Parallel Sorting Algorithms (Lab 9)](#10-lab9--gpu-computing-with-cuda-parallel-sorting-algorithms-lab-9)
  - [11. `pcap/` — Reference Labs & Additional Problem Sets (Labs 1–10)](#11-pcap--reference-labs--additional-problem-sets-labs-110)
- [Prerequisites & Environment Setup](#prerequisites--environment-setup)
  - [MPI Setup (macOS / Linux)](#mpi-setup-macos--linux)
  - [OpenMP Setup (macOS GCC vs Apple Clang)](#openmp-setup-macos-gcc-vs-apple-clang)
  - [CUDA Setup (NVIDIA Toolchain)](#cuda-setup-nvidia-toolchain)
- [Compilation & Execution Quick Reference](#compilation--execution-quick-reference)

---

## Repository Architecture

```text
HPCS/
├── README.md                      # Master repository documentation (this file)
├── mpi_intro/                     # Lab 1: MPI fundamentals, rank logic, SPMD execution
│   ├── q1/ ... q6/                # Standalone question directories
│   └── README.md
├── blockingmsgpassing/            # MPI blocking send/receive primitives
│   ├── standard/                  # Standard MPI_Send and MPI_Recv
│   ├── stdwithstatus/             # MPI_Status inspection
│   ├── syncsend/                  # Synchronous send (MPI_Ssend)
│   ├── bufferedsend/              # User-buffered send (MPI_Bsend / MPI_Buffer_attach)
│   └── README.md
├── lab2/                          # Lab 2: Point-to-point communication & data partitioning
│   ├── q1/ ... q5/                # Calculator, sync toggle, array sum/search, primes
│   └── README.md
├── lab3/                          # Lab 3: MPI collective operations (Scatter, Gather, Bcast)
│   ├── q1/ ... q4/                # Factorials, averages, string interleaving, rank powers
│   └── README.md
├── lab4/                          # Lab 4: Advanced collectives (Scan, Reduce, Wtime)
│   ├── q1/ ... q4/                # Factorial prefix sum, matrix search, matrix scan, word expander
│   └── README.md
├── lab5/                          # Lab 5: OpenMP shared-memory programming
│   ├── HelloWorld/                # Thread creation and thread ID reporting
│   ├── q1/ ... q8/                # Scopes, parallel for, reductions, collapse(2), locks
│   └── README.md
├── lab6/                          # Lab 6: CUDA basics on 1-D vectors
│   ├── q1/ ... q3/                # Vector add, decimal-to-octal, alternating swap
│   └── README.md
├── lab7/                          # Lab 7: CUDA string manipulation & kernel profiling
│   ├── q1/ ... q4/                # Case toggle, ASCII digit reversal, string repeat, word reverse
│   └── README.md
├── lab8/                          # Lab 8: CUDA 2-D matrices & grid/block dimensioning
│   ├── q1/ ... q4/                # Matmul, 3 thread mappings (row/col/elem), transform, 2D grid/block
│   └── README.md
├── lab9/                          # Lab 9: CUDA parallel sorting techniques
│   ├── q1/ ... q3/                # String selection sort, per-word sort, odd-even transposition sort
│   └── README.md
└── pcap/                          # Reference solutions & supplementary/advanced problems (Labs 1–10)
    ├── lab1/ ... lab10/           # Including Lab 10 constant memory convolution
    └── (various subfolders)
```

---

## Computing Paradigms Comparison

| Paradigm | Framework | Memory Model | Execution Model | Scaling Boundary | Primary Use Cases |
|---|---|---|---|---|---|
| **Message Passing** | **MPI** | Distributed (no shared address space) | Single Program Multiple Data (SPMD) processes | Cluster nodes, supercomputers, multi-node network | Large-scale simulations, domain decomposition, distributed reductions |
| **Multi-threading** | **OpenMP** | Shared memory (uniform address space) | Fork-join thread pool | Multi-core symmetric multiprocessing (SMP) CPUs | Loop parallelization, parallel reduction, pipeline tasks |
| **Massively Parallel** | **NVIDIA CUDA** | Hierarchical device memory (Global, Shared, Constant, Local) | Single Instruction Multiple Threads (SIMT) | GPU streaming multiprocessors (thousands of cores) | Vector arithmetic, matrix operations, dense image/signal processing |

---

## Module Index & Lab Descriptions

### 1. [`mpi_intro/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro) — Introduction to MPI (Lab 1)

Focuses on the SPMD paradigm, basic process lifecycle (`MPI_Init`, `MPI_Finalize`), communicator size (`MPI_Comm_size`), and rank identification (`MPI_Comm_rank`).

| Directory | Program | Concept / Description |
|---|---|---|
| [`mpi_intro/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q1) | `sample.c` | Identifies each process's rank and the total process count in `MPI_COMM_WORLD`. |
| [`mpi_intro/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q2) | `sample.c` | Computes $x^{\text{rank}}$ ($x=2.0$) per process using math library (`-lm`). |
| [`mpi_intro/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q3) | `sample.c` | Distributed arithmetic calculator (Rank 0: $+$, Rank 1: $-$, Rank 2: $*$, Rank 3: $/$). |
| [`mpi_intro/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q4) | `sample.c` | Rank parity branching: even ranks print `Hello`, odd ranks print `World`. |
| [`mpi_intro/q5`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q5) | `sample.c` | Character case toggling: process $i$ toggles character $i$ of string `"HELLO"`. |
| [`mpi_intro/q6`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/q6) | `sample.c` | Parity computation: even ranks compute $\text{rank}!$, odd ranks compute $\text{Fibonacci}(\text{rank})$. |

*Documentation:* [`mpi_intro/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/mpi_intro/README.md)

---

### 2. [`blockingmsgpassing/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing) — Point-to-Point Blocking Communication

Demonstrates the four primary semantic variations of point-to-point blocking communication in MPI.

| Subdirectory | Mechanism | Function Calls | Semantics & Buffer Behavior |
|---|---|---|---|
| [`standard/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing/standard) | Standard Blocking | `MPI_Send`, `MPI_Recv` | May or may not buffer internally depending on message size and MPI implementation. |
| [`stdwithstatus/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing/stdwithstatus) | Status Inspection | `MPI_Recv(..., &status)`, `MPI_Get_count` | Inspects `MPI_Status` (`MPI_SOURCE`, `MPI_TAG`, and actual byte/element count). |
| [`syncsend/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing/syncsend) | Synchronous Send | `MPI_Ssend`, `MPI_Recv` | Send does **not** complete until the matching receive has begun receiving the data (rendezvous). |
| [`bufferedsend/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing/bufferedsend) | Buffered Send | `MPI_Buffer_attach`, `MPI_Bsend`, `MPI_Buffer_detach` | Explicit user-allocated buffer; send returns as soon as data is staged into the buffer. |

*Documentation:* [`blockingmsgpassing/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/blockingmsgpassing/README.md)

---

### 3. [`lab2/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2) — Data Partitioning & Synchronous Communication (Lab 2)

Covers point-to-point coordination between processes to split workloads, execute synchronous handshakes, and partition 1-D arrays.

| Directory | Program | Concept / Description |
|---|---|---|
| [`lab2/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/q1) | `sample.c` | Master process (Rank 0) reads two operands and sends them to workers; ranks 1–4 execute $+$, $-$, $*$, and $/$ and return results. |
| [`lab2/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/q2) | `sample.c` | Bidirectional ping-pong message exchange using synchronous `MPI_Ssend` and `MPI_Recv`. |
| [`lab2/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/q3) | `sample.c` | Array sum partitioning: array of numbers divided evenly between process 0 and process 1; partial sums combined at root. |
| [`lab2/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/q4) | `sample.c` | Parallel linear search: array partitioned across 2 processes; both search independently for key and report findings. |
| [`lab2/q5`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/q5) | `sample.c` | Prime number generation partitioned across 2 processes over disjoint integer ranges. |

*Documentation:* [`lab2/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab2/README.md)

---

### 4. [`lab3/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3) — Collective Communication: Broadcast, Scatter & Gather (Lab 3)

Replaces point-to-point loops with high-performance collective operations that utilize hardware-optimized communication trees.

| Directory | Program | Collective Operations | Description |
|---|---|---|---|
| [`lab3/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3/q1) | `sample.c` | `MPI_Scatter`, `MPI_Gather` | Scatters $N$ individual integers to $N$ processes; each computes $x!$; root gathers and displays factorials. |
| [`lab3/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3/q2) | `sample.c` | `MPI_Bcast`, `MPI_Scatter`, `MPI_Gather` | Scatters blocks of $M$ integers to $N$ processes; calculates local block averages and aggregates global average. |
| [`lab3/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3/q3) | `sample.c` | `MPI_Scatter`, `MPI_Gather` | String interleaving: splits two strings into chunks across ranks, interleaves characters locally, gathers into final string. |
| [`lab3/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3/q4) | `sample.c` | `MPI_Bcast`, `MPI_Scatter`, `MPI_Gather` | Powers by rank: distributes $M$ values per process, each process raises its items to power $(\text{rank}+1)$ and gathers output. |

*Documentation:* [`lab3/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab3/README.md)

---

### 5. [`lab4/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4) — Advanced Collectives: Scans, Reductions & Timing (Lab 4)

Covers inclusive prefix scans (`MPI_Scan`), global reductions (`MPI_Reduce`), barrier synchronization (`MPI_Barrier`), and high-precision timing (`MPI_Wtime`).

| Directory | Program | Concept / Description |
|---|---|---|
| [`lab4/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4/q1) | `sample.c` | Evaluates $1! + 2! + \dots + N!$ via dual `MPI_Scan` (`MPI_PROD` for factorial, `MPI_SUM` for cumulative sum) with `MPI_Wtime` profiling. |
| [`lab4/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4/q2) | `sample.c` | $3 \times 3$ matrix search: broadcast search key, scatter rows, local frequency counts reduced to root via `MPI_Reduce` (`MPI_SUM`). |
| [`lab4/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4/q3) | `sample.c` | $4 \times 4$ matrix column prefix sum: scatters rows, performs vector `MPI_Scan` across columns, gathers result. |
| [`lab4/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4/q4) | `sample.c` | String pattern expansion (e.g. `PCAP` $\to$ `PCCAAAPPPP`): rank $i$ duplicates character $(i+1)$ times; gathered and timed. |

*Documentation:* [`lab4/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab4/README.md)

---

### 6. [`lab5/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5) — Shared-Memory Multi-Threading with OpenMP (Lab 5)

Covers compiler directives (`#pragma omp`), data sharing attributes (`shared`, `private`), work-sharing loops, reduction clauses, multi-loop collapse, and OpenMP locks.

| Directory | Program(s) | OpenMP Directives & Concepts | Description |
|---|---|---|---|
| [`lab5/HelloWorld`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/HelloWorld) | `sample.c` | `#pragma omp parallel`, `omp_get_thread_num`, `omp_get_num_threads` | Spawns a team of threads, printing thread IDs and team size. |
| [`lab5/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q1) | `sample.c` | `shared(var)`, `private(var)` | Demonstrates scope differences: shared variable mutations persist; private variables are thread-local. |
| [`lab5/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q2) | `sample1.c`, `sample2.c` | `#pragma omp parallel for`, `num_threads(24)` | Element-wise vector addition; compares default core thread allocation against explicit thread scaling. |
| [`lab5/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q3) | `sample1.c`, `sample2.c` | `#pragma omp critical` vs `reduction(+:sum)` | Evaluates $\sum_{i=1}^N i$; contrasts critical section synchronization overhead with optimized hardware reduction trees. |
| [`lab5/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q4) | `sample.c` | `#pragma omp parallel for collapse(2)` | Flattens 2-D nested loop ($4 \times 4$ matrix add) into a single iteration space distributed across threads. |
| [`lab5/q5`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q5) | `sample.c` | `parallel for reduction(+:sum)` | Calculates sum of first 100 integers and compares against formula $n(n+1)/2$. |
| [`lab5/q6`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q6) | `sample.c` | `parallel for reduction(max:max_val)` | Computes the maximum element of an integer array in parallel. |
| [`lab5/q7`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q7) | `sample.c` | Static work distribution | Computes distinct factorials concurrently, one unique value per thread. |
| [`lab5/q8`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/q8) | `sample.c` | `omp_lock_t`, `omp_init_lock`, `omp_set_lock`, `omp_unset_lock` | Protects a shared counter across high-frequency increments ($4 \times 100,000$) to guarantee race-free accuracy. |

*Documentation:* [`lab5/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab5/README.md)

---

### 7. [`lab6/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab6) — GPU Computing with CUDA: Vectors & Memory Transfers (Lab 6)

Introduces CUDA execution model (`__global__`), memory management (`cudaMalloc`, `cudaFree`), bidirectional transfers (`cudaMemcpyHostToDevice`, `cudaMemcpyDeviceToHost`), and 1-D thread index computation (`blockIdx.x * blockDim.x + threadIdx.x`).

| Directory | Program | Kernel Function | Description |
|---|---|---|---|
| [`lab6/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab6/q1) | `sample.cu` | `vectorAdd<<<blocks, threads>>>` | Element-wise vector addition $C[i] = A[i] + B[i]$ over $N$ items using 256 threads per block. |
| [`lab6/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab6/q2) | `sample.cu` | `decToOctal<<<blocks, threads>>>` | Converts $N$ decimal integers to octal representations simultaneously on device threads. |
| [`lab6/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab6/q3) | `sample.cu` | `swapAdjacent<<<blocks, threads>>>` | In-place device array swap of adjacent odd/even element pairs ($a[2i] \leftrightarrow a[2i+1]$). |

*Documentation:* [`lab6/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab6/README.md)

---

### 8. [`lab7/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7) — GPU Computing with CUDA: Parallel String Processing (Lab 7)

Applies SIMT thread hierarchies to character arrays, text transformations, and CUDA event-based kernel micro-benchmarking (`cudaEventRecord`, `cudaEventElapsedTime`).

| Directory | Program | Concept / Description |
|---|---|---|
| [`lab7/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7/q1) | `sample.cu` | Parallel character case toggling (lower $\leftrightarrow$ upper) with CUDA event kernel timing vs CPU wall-clock timing. |
| [`lab7/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7/q2) | `sample.cu` | ASCII digit reversal: transforms each character's ASCII integer representation into reversed digits in parallel. |
| [`lab7/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7/q3) | `sample.cu` | String repetition: generates $N$ repeated copies of string $S$ in parallel using modulo indexing `out[i] = S[i % len]`. |
| [`lab7/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7/q4) | `sample.cu` | Per-word parallel reversal: host identifies word bounds; GPU threads reverse their assigned word in-place while preserving whitespace. |

*Documentation:* [`lab7/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab7/README.md)

---

### 9. [`lab8/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8) — GPU Computing with CUDA: 2-D Matrices & Thread Mapping (Lab 8)

Explores multi-dimensional grid and block topologies (`dim3`), row-major index mapping, and three distinct thread-to-data mapping strategies.

| Directory | Program(s) | Dimensioning & Mapping | Description |
|---|---|---|---|
| [`lab8/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8/q1) | `sample.cu` | 1 thread per element | General matrix multiplication $C_{M \times P} = A_{M \times N} \times B_{N \times P}$ with CUDA event profiling. |
| [`lab8/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8/q2) | `sample_a.cu` | 1 thread per **row** | Matrix addition: thread $i$ iterates through all columns of row $i$. |
| | `sample_b.cu` | 1 thread per **column** | Matrix addition: thread $j$ iterates through all rows of column $j$. |
| | `sample_c.cu` | 1 thread per **element** | Matrix addition: thread $k$ directly updates $C[k] = A[k] + B[k]$. |
| [`lab8/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8/q3) | `sample.cu` | Element mapping | Square matrix transform: diagonal $\to 0$, above diagonal $\to \text{factorial}(A_{ij})$, below diagonal $\to \text{digit\_sum}(A_{ij})$. |
| [`lab8/q4`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8/q4) | `sample.cu` | 2-D Grid + 2-D Block (`dim3`) | Both matrix addition and multiplication implemented using `dim3 threads(16, 16)` and 2-D block indices (`threadIdx.x/y`). |

*Documentation:* [`lab8/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab8/README.md)

---

### 10. [`lab9/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab9) — GPU Computing with CUDA: Parallel Sorting Algorithms (Lab 9)

Implements comparison and transposition sorting algorithms tailored for parallel execution on the GPU.

| Directory | Program | Sorting Algorithm | GPU Strategy |
|---|---|---|---|
| [`lab9/q1`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab9/q1) | `sample.cu` | Selection Sort (whole string) | Character array sorted in device memory by finding and swapping minimum elements. |
| [`lab9/q2`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab9/q2) | `sample.cu` | Per-word Parallel Selection Sort | Each thread $w$ independently sorts word $w$ within its slice of the device buffer. |
| [`lab9/q3`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab9/q3) | `sample.cu` | Odd-Even Transposition Sort | Two-kernel synchronization: alternating `evenPhase` (pairs $2k, 2k+1$) and `oddPhase` (pairs $2k+1, 2k+2$) repeated $N$ times. |

*Documentation:* [`lab9/README.md`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/lab9/README.md)

---

### 11. [`pcap/`](file:///Users/yogeshkulkarni/Documents/Manipal_Edu/HPCS/pcap) — Reference Labs & Additional Problem Sets (Labs 1–10)

Contains additional exercises, alternate implementations, and advanced lab problems from the companion PCAP laboratory curriculum:

- **Lab 1**: Additional array digit reversal with MPI.
- **Lab 2**: Master-worker synchronous exchanges and partitioned search routines.
- **Lab 3**: String pattern interleaving and collective power reduction variations.
- **Lab 4**: Collective prefix calculations.
- **Lab 5**: CUDA 1-D vector addition under varying thread/block constraints (1 block of $N$ threads, $N$ blocks of 1 thread, etc.).
- **Lab 6 & 7**: Advanced CUDA vector transformations and string manipulation variants.
- **Lab 8**: Matrix transformations and additional row/column dispatch variations.
- **Lab 9**: Additional sorting exercises.
- **Lab 10**: Advanced GPU memory models:
  - `lab10/q2`: **1-D Convolution using Constant Memory** (`__constant__ float d_mask[64]`), demonstrating cached read broadcast performance.
  - `lab10/q3`: Additional constant memory / shared memory parallel stencils.

---

## Prerequisites & Environment Setup

### MPI Setup (macOS / Linux)

To compile and run MPI programs:

```bash
# macOS (via Homebrew)
brew install open-mpi

# Ubuntu / Debian Linux
sudo apt update && sudo apt install -y openmpi-bin libopenmpi-dev
```

Verify installation:
```bash
mpicc --version
mpirun --version
```

### OpenMP Setup (macOS GCC vs Apple Clang)

> [!WARNING]
> On macOS, the default system `/usr/bin/gcc` is an Apple Clang wrapper. Apple Clang **does not support** the `-fopenmp` flag and will return:
> `clang: error: unsupported option '-fopenmp'`.

To compile OpenMP programs on macOS, use **Homebrew GCC**:

```bash
# Install Homebrew GCC and OpenMP runtime
brew install gcc libomp
```

Identify your installed GCC version (e.g., `gcc-14`, `gcc-15`, `gcc-16`):
```bash
which gcc-16
```

#### Recommended Compile Command:
```bash
gcc-16 -fopenmp sample.c -o sample.out
./sample.out
```

#### Optional Shell Alias (Add to `~/.zshrc`):
```bash
alias ompcc='gcc-16 -fopenmp'
```

#### Alternate via Apple Clang + libomp:
```bash
clang -Xpreprocessor -fopenmp \
  -I/opt/homebrew/opt/libomp/include \
  -L/opt/homebrew/opt/libomp/lib \
  -lomp sample.c -o sample.out
```

### CUDA Setup (NVIDIA Toolchain)

CUDA programs require an NVIDIA GPU with compute capability support and the NVIDIA CUDA Toolkit (`nvcc`).

```bash
# Verify NVIDIA GPU and driver
nvidia-smi

# Verify CUDA Compiler
nvcc --version
```

*Note: CUDA code (`.cu`) cannot run natively on Apple Silicon / macOS. Run on an NVIDIA-equipped workstation, university lab system, or Linux/Cloud GPU instance (e.g. AWS, GCP, Google Colab).*

---

## Compilation & Execution Quick Reference

### MPI Programs
```bash
# Compile
mpicc -o sample.out sample.c

# Compile with Math library (e.g., pow(), sqrt())
mpicc -o sample.out sample.c -lm

# Run with N processes
mpirun -np 4 ./sample.out

# Alternative launcher if mpirun is not default
mpiexec -n 4 ./sample.out
```

### OpenMP Programs
```bash
# Compile with Homebrew GCC on macOS
gcc-16 -fopenmp sample.c -o sample.out

# Compile on standard Linux
gcc -fopenmp sample.c -o sample.out

# Run with custom thread count (e.g. 4 threads)
OMP_NUM_THREADS=4 ./sample.out
```

### CUDA Programs
```bash
# Compile CUDA source
nvcc sample.cu -o sample.out

# Compile with optimization flags
nvcc -O3 sample.cu -o sample.out

# Run
./sample.out
```

---

## Contributing & Academic Integrity

All code files within this repository are structured for educational and laboratory coursework purposes. When referencing or utilizing code for academic assignments, ensure compliance with institutional academic integrity policies.
