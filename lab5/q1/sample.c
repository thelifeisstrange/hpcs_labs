// q1) Write an OpenMP program to use variables as shared or private

#include <stdio.h>
#include <omp.h>

int main() {
    int shared_var = 10;
    int private_var = 10;

    printf("Before parallel region: shared_var = %d, private_var = %d\n\n",
           shared_var, private_var);

    omp_set_num_threads(4);

    #pragma omp parallel shared(shared_var)
    {
        int tid = omp_get_thread_num();
        #pragma omp critical
        {
            shared_var += 1;
            printf("Thread %d updated shared_var = %d\n", tid, shared_var);
        }
    }
    printf("After shared region: shared_var = %d (changed)\n\n", shared_var);

    #pragma omp parallel private(private_var)
    {
        int tid = omp_get_thread_num();
        private_var = tid + 1;
        printf("Thread %d private_var = %d\n", tid, private_var);
    }
    printf("After private region: private_var = %d (original unchanged)\n", private_var);

    return 0;
}
