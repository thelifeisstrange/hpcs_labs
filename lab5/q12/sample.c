// 4) OpenMP program for pi calculation (Leibniz series).

#include <stdio.h>
#include <omp.h>

int main(void)
{
    long long n = 100000000;
    double sum = 0.0, pi, t0, t1;

    t0 = omp_get_wtime();
    #pragma omp parallel for reduction(+:sum)
    for (long long i = 0; i < n; i++) {
        double term = (i % 2 == 0) ? 1.0 : -1.0;
        sum += term / (2.0 * i + 1.0);
    }
    pi = 4.0 * sum;
    t1 = omp_get_wtime();

    printf("pi ≈ %.10f\n", pi);
    printf("terms = %lld, time = %lf s, threads = %d\n",
           n, t1 - t0, omp_get_max_threads());
    return 0;
}
