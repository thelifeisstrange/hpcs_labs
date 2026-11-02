// 1) Sort an array of n elements using parallel merge sort with sections.

#include <stdio.h>
#include <omp.h>

void merge(int a[], int l, int m, int r)
{
    int n1 = m - l + 1, n2 = r - m;
    int L[n1], R[n2];
    for (int i = 0; i < n1; i++)
        L[i] = a[l + i];
    for (int j = 0; j < n2; j++)
        R[j] = a[m + 1 + j];
    int i = 0, j = 0, k = l;
    while (i < n1 && j < n2)
        a[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];
    while (i < n1)
        a[k++] = L[i++];
    while (j < n2)
        a[k++] = R[j++];
}

void mergesort(int a[], int l, int r)
{
    if (l >= r)
        return;
    int m = (l + r) / 2;
    #pragma omp parallel sections
    {
        #pragma omp section
        mergesort(a, l, m);
        #pragma omp section
        mergesort(a, m + 1, r);
    }
    merge(a, l, m, r);
}

int main(void)
{
    int a[] = {38, 27, 43, 3, 9, 82, 10, 15};
    int n = 8;

    printf("Before: ");
    for (int i = 0; i < n; i++)
        printf("%d ", a[i]);
    printf("\n");

    mergesort(a, 0, n - 1);

    printf("After:  ");
    for (int i = 0; i < n; i++)
        printf("%d ", a[i]);
    printf("\n");
    return 0;
}
