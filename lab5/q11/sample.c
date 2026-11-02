// 3) Find primes from 1 to n with parallel for. Record serial and parallel time.

#include <stdio.h>
#include <omp.h>

int is_prime(int x)
{
    if (x < 2)
        return 0;
    for (int i = 2; i * i <= x; i++)
        if (x % i == 0)
            return 0;
    return 1;
}

int main(void)
{
    int n = 10000;
    int count_s = 0, count_p = 0;
    double t0, t1;

    t0 = omp_get_wtime();
    for (int i = 1; i <= n; i++)
        if (is_prime(i))
            count_s++;
    t1 = omp_get_wtime();
    printf("Serial:   primes=%d  time=%lf s\n", count_s, t1 - t0);

    t0 = omp_get_wtime();
    #pragma omp parallel for reduction(+:count_p)
    for (int i = 1; i <= n; i++)
        if (is_prime(i))
            count_p++;
    t1 = omp_get_wtime();
    printf("Parallel: primes=%d  time=%lf s\n", count_p, t1 - t0);
    printf("Threads used = %d\n", omp_get_max_threads());
    return 0;
}
