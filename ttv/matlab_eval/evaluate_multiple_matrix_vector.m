addpath('/home/bascem/');

x = 16:16:256;

run('multiple_matrix_vector_order1_dim1');

mmv_openblas_order1_dim1_flops=tlib_ttv_small_block_parallel_openblas_order1_dim1_ops./tlib_ttv_small_block_parallel_openblas_order1_dim1_time;
mmv_openblas_order1_dim1_gflops=mmv_openblas_order1_dim1_flops*10^-9;
figure('name','Openblas-Vektor-Matrix-Column-Major');plot(x,mmv_openblas_order1_dim1_gflops);

mmv_mkl_order1_dim1_flops=tlib_ttv_small_block_parallel_mkl_order1_dim1_ops./tlib_ttv_small_block_parallel_mkl_order1_dim1_time;
mmv_mkl_order1_dim1_gflops=mmv_mkl_order1_dim1_flops*10^-9;
figure('name','Mkl-Vektor-Matrix-Column-Major');plot(x,mmv_mkl_order1_dim1_gflops);

%%%%%%%%%%%%%%%%%%%%%%%

run('multiple_matrix_vector_order1_dim2');

mmv_openblas_order1_dim2_flops=tlib_ttv_small_block_parallel_openblas_order1_dim2_ops./tlib_ttv_small_block_parallel_openblas_order1_dim2_time;
mmv_openblas_order1_dim2_gflops=mmv_openblas_order1_dim2_flops*10^-9;
figure('name','Openblas-Matrix-Vektor-Column-Major');plot(x,mmv_openblas_order1_dim2_gflops);

mmv_mkl_order1_dim2_flops=tlib_ttv_small_block_parallel_mkl_order1_dim2_ops./tlib_ttv_small_block_parallel_mkl_order1_dim2_time;
mmv_mkl_order1_dim2_gflops=mmv_mkl_order1_dim2_flops*10^-9;
figure('name','Mkl-Matrix-Vektor-Column-Major');plot(x,mmv_mkl_order1_dim2_gflops);

%%%%%%%%%%%%%%%%%%%%%%%

run('multiple_matrix_vector_order2_dim1');

mmv_openblas_order2_dim1_flops=tlib_ttv_small_block_parallel_openblas_order2_dim1_ops./tlib_ttv_small_block_parallel_openblas_order2_dim1_time;
mmv_openblas_order2_dim1_gflops=mmv_openblas_order2_dim1_flops*10^-9;
figure('name','Openblas-Vektor-Matrix-Row-Major');plot(x,mmv_openblas_order2_dim1_gflops);

mmv_mkl_order2_dim1_flops=tlib_ttv_small_block_parallel_mkl_order2_dim1_ops./tlib_ttv_small_block_parallel_mkl_order2_dim1_time;
mmv_mkl_order2_dim1_gflops=mmv_mkl_order2_dim1_flops*10^-9;
figure('name','Mkl-Vektor-Matrix-Row-Major');plot(x,mmv_mkl_order2_dim1_gflops);


%%%%%%%%%%%%%%%%%%%%%%%

run('multiple_matrix_vector_order2_dim2');

mmv_openblas_order2_dim2_flops=tlib_ttv_small_block_parallel_openblas_order2_dim2_ops./tlib_ttv_small_block_parallel_openblas_order2_dim2_time;
mmv_openblas_order2_dim2_gflops=mmv_openblas_order2_dim2_flops*10^-9;
figure('name','Openblas-Matrix-Vektor-Row-Major');plot(x,mmv_openblas_order2_dim2_gflops);

mmv_mkl_order2_dim2_flops=tlib_ttv_small_block_parallel_mkl_order2_dim2_ops./tlib_ttv_small_block_parallel_mkl_order2_dim2_time;
mmv_mkl_order2_dim2_gflops=mmv_mkl_order2_dim2_flops*10^-9;
figure('name','Mkl-Matrix-Vektor-Row-Major');plot(x,mmv_mkl_order2_dim2_gflops);



