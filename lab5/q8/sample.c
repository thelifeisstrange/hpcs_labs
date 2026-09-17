// q8) Write a program using locks to implement a safe increment counter
// with multiple threads.

#include <stdio.h>
#include <omp.h>

int main() {
    int counter = 0;
    omp_lock_t lock;
    int nthreads = 4;
    int increments_per_thread = 100000;

    omp_init_lock(&lock);
    omp_set_num_threads(nthreads);

    #pragma omp parallel
    {
        for (int i = 0; i < increments_per_thread; i++) {
            omp_set_lock(&lock);
            counter++;
            omp_unset_lock(&lock);
        }
    }

    omp_destroy_lock(&lock);

    printf("Threads = %d, increments per thread = %d\n",
           nthreads, increments_per_thread);
    printf("Final counter = %d\n", counter);
    printf("Expected = %d\n", nthreads * increments_per_thread);

    return 0;
}
