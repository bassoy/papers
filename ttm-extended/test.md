BLIS_USED=1 OMP_PLACES=cores ./test 5   7 6    8 8 8 8 8 8 8
ttm : C[a,b,c,d,e,m,g] = A[a,b,c,d,e,f,g] x(6) B[m,f];
Measure: <par-loop | slice-2d>
Gemm Dims: m = 8, n = 8, k = 8, m*n*k = 512
Par Dim: l = 262144
Memory: 0.0335549 [GB]
Time : 0.0139738 [s]
Gflops : 0.0314573 [gflops]
Performance : 2.25117 [gflops/s]
---------

Measure: <par-loop | slice-qd>
Par Dim: l = 8
Gemm Dims: m = 32768, n = 8, k = 8, m*k = 262144, m*k/l = 32768, m/k = 4096
Memory: 0.0335549 [GB]
Time : 0.000417539 [s]
Gflops : 0.0314573 [gflops]
Performance : 75.3397 [gflops/s]
---------

Measure: <par-gemm | slice-2d>
Gemm Dims: m = 8, n = 8, k = 8, m*n*k = 512
Par Dim: l = 262144
Memory: 0.0335549 [GB]
Time : 5.40102 [s]
Gflops : 0.0314573 [gflops]
Performance : 0.00582432 [gflops/s]
---------

Measure: <par-gemm | slice-qd>
Par Dim: l = 8
Gemm Dims: m = 32768, n = 8, k = 8, m*k = 262144, m*k/l = 32768, m/k = 4096
Memory: 0.0335549 [GB]
Time : 0.00237049 [s]
Gflops : 0.0314573 [gflops]
Performance : 13.2704 [gflops/s]
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


MKL_USED=1 OMP_PLACES=cores ./test 5   7 6    8 8 8 8 8 8 8

ttm : C[a,b,c,d,e,m,g] = A[a,b,c,d,e,f,g] x(6) B[m,f];
Measure: <par-loop | slice-2d>
Gemm Dims: m = 8, n = 8, k = 8, m*n*k = 512
Par Dim: l = 262144
Memory: 0.0335549 [GB]
Time : 0.00311445 [s]
Gflops : 0.0314573 [gflops]
Performance : 10.1004 [gflops/s]
---------

Measure: <par-loop | slice-qd>
Par Dim: l = 8
Gemm Dims: m = 32768, n = 8, k = 8, m*k = 262144, m*k/l = 32768, m/k = 4096
Memory: 0.0335549 [GB]
Time : 0.000695458 [s]
Gflops : 0.0314573 [gflops]
Performance : 45.2325 [gflops/s]
---------

Measure: <par-gemm | slice-2d>
Gemm Dims: m = 8, n = 8, k = 8, m*n*k = 512
Par Dim: l = 262144
Memory: 0.0335549 [GB]
Time : 0.00917774 [s]
Gflops : 0.0314573 [gflops]
Performance : 3.42756 [gflops/s]
---------

Measure: <par-gemm | slice-qd>
Par Dim: l = 8
Gemm Dims: m = 32768, n = 8, k = 8, m*k = 262144, m*k/l = 32768, m/k = 4096
Memory: 0.0335549 [GB]
Time : 0.000882835 [s]
Gflops : 0.0314573 [gflops]
Performance : 35.6321 [gflops/s]


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


BLIS_USED=1 OMP_PLACES=cores ./test 5   7 6    16 16 16 16 16 16 16


ttm : C[a,b,c,d,e,m,g] = A[a,b,c,d,e,f,g] x(6) B[m,f];
Measure: <par-loop | slice-2d>
Gemm Dims: m = 16, n = 16, k = 16, m*n*k = 4096
Par Dim: l = 1.67772e+07
Memory: 4.29497 [GB]
Time : 0.632146 [s]
Gflops : 8.3215 [gflops]
Performance : 13.1639 [gflops/s]
---------

Measure: <par-loop | slice-qd>
Par Dim: l = 16
Gemm Dims: m = 1.04858e+06, n = 16, k = 16, m*k = 1.67772e+07, m*k/l = 1.04858e+06, m/k = 65536
Memory: 4.29497 [GB]
Time : 0.0743225 [s]
Gflops : 8.3215 [gflops]
Performance : 111.965 [gflops/s]
---------

Measure: <par-gemm | slice-qd>
Par Dim: l = 16
Gemm Dims: m = 1.04858e+06, n = 16, k = 16, m*k = 1.67772e+07, m*k/l = 1.04858e+06, m/k = 65536
Memory: 4.29497 [GB]
Time : 0.201102 [s]
Gflops : 8.3215 [gflops]
Performance : 41.3794 [gflops/s]


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

MKL_USED=1 OMP_PLACES=cores ./test 5   7 6    16 16 16 16 16 16 16


ttm : C[a,b,c,d,e,m,g] = A[a,b,c,d,e,f,g] x(6) B[m,f];
Measure: <par-loop | slice-2d>
Gemm Dims: m = 16, n = 16, k = 16, m*n*k = 4096
Par Dim: l = 1.67772e+07
Memory: 4.29497 [GB]
Time : 0.221861 [s]
Gflops : 8.3215 [gflops]
Performance : 37.5076 [gflops/s]
---------

Measure: <par-loop | slice-qd>
Par Dim: l = 16
Gemm Dims: m = 1.04858e+06, n = 16, k = 16, m*k = 1.67772e+07, m*k/l = 1.04858e+06, m/k = 65536
Memory: 4.29497 [GB]
Time : 0.277859 [s]
Gflops : 8.3215 [gflops]
Performance : 29.9486 [gflops/s]
---------

Measure: <par-gemm | slice-qd>
Par Dim: l = 16
Gemm Dims: m = 1.04858e+06, n = 16, k = 16, m*k = 1.67772e+07, m*k/l = 1.04858e+06, m/k = 65536
Memory: 4.29497 [GB]
Time : 0.609672 [s]
Gflops : 8.3215 [gflops]
Performance : 13.6491 [gflops/s]
---------





---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

MKL_USED=1 OMP_PLACES=cores ./test 7   4 2    128 128 128 128


ttm : C[a,m,c,d] = A[a,b,c,d] x(2) B[m,b];
Measure: <par-loop | slice-2d, all>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 0.186758 [s]
Gflops : 68.451 [gflops]
Performance : 366.523 [gflops/s]
---------

Measure: <par-loop | slice-qd, all>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 0.176967 [s]
Gflops : 68.451 [gflops]
Performance : 386.801 [gflops/s]
---------

Measure: <par-gemm | slice-2d, none>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 0.330578 [s]
Gflops : 68.451 [gflops]
Performance : 207.065 [gflops/s]
---------

Measure: <par-gemm | slice-2d, all>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 0.330012 [s]
Gflops : 68.451 [gflops]
Performance : 207.42 [gflops/s]
---------

Measure: <par-gemm | slice-qd, none>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 0.332288 [s]
Gflops : 68.451 [gflops]
Performance : 205.999 [gflops/s]
---------

Measure: <par-gemm | slice-qd, all>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 0.329899 [s]
Gflops : 68.451 [gflops]
Performance : 207.491 [gflops/s]


---------------------------------------------------------------------------------------------------

BLIS_USED=1 OMP_PLACES=cores ./test 7   4 2    128 128 128 128

ttm : C[a,m,c,d] = A[a,b,c,d] x(2) B[m,b];
Measure: <par-loop | slice-2d, all>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 0.1607 [s]
Gflops : 68.451 [gflops]
Performance : 425.956 [gflops/s]
---------

Measure: <par-loop | slice-qd, all>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 0.155426 [s]
Gflops : 68.451 [gflops]
Performance : 440.409 [gflops/s]
---------

Measure: <par-gemm | slice-2d, none>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 3.17523 [s]
Gflops : 68.451 [gflops]
Performance : 21.5578 [gflops/s]
---------

Measure: <par-gemm | slice-2d, all>
Gemm Dims: m = 128, n = 128, k = 128, m*n*k = 2097152
Par Dim: l = 2.09715e+06
Memory: 4.2951 [GB]
Time : 3.13645 [s]
Gflops : 68.451 [gflops]
Performance : 21.8244 [gflops/s]
---------

Measure: <par-gemm | slice-qd, none>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 3.11031 [s]
Gflops : 68.451 [gflops]
Performance : 22.0078 [gflops/s]
---------

Measure: <par-gemm | slice-qd, all>
Par Dim: l = 16384
Gemm Dims: m = 128, n = 128, k = 128, m*k = 16384, m*k/l = 1, m/k = 1
Memory: 4.2951 [GB]
Time : 3.21833 [s]
Gflops : 68.451 [gflops]
Performance : 21.2691 [gflops/s]
---------

