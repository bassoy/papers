addpath('/home/bascem/');

run('matrix_vector_order1_dim1');

mv_blis_order1_dim1_flops=tlib_ttv_small_block_parallel_blis_order1_dim1_ops./tlib_ttv_small_block_parallel_blis_order1_dim1_time;
mv_blis_order1_dim1_gflops=mv_blis_order1_dim1_flops*10^-9;
figure('name','Blis-Vektor-Matrix-Column-Major'); 
plot(256:256:256*256,mv_blis_order1_dim1_gflops); 
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Blis-Vector-Times-Matrix (CM) \pi=[1,2], m=1')

mv_openblas_order1_dim1_flops=tlib_ttv_small_block_parallel_openblas_order1_dim1_ops./tlib_ttv_small_block_parallel_openblas_order1_dim1_time;
mv_openblas_order1_dim1_gflops=mv_openblas_order1_dim1_flops*10^-9;
figure('name','Openblas-Vektor-Matrix-Column-Major');plot(256:256:256*256,mv_openblas_order1_dim1_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Openblas-Vector-Times-Matrix (CM) \pi=[1,2], m=1')

mv_mkl_order1_dim1_flops=tlib_ttv_small_block_parallel_mkl_order1_dim1_ops./tlib_ttv_small_block_parallel_mkl_order1_dim1_time;
mv_mkl_order1_dim1_gflops=mv_mkl_order1_dim1_flops*10^-9;
figure('name','Mkl-Vektor-Matrix-Column-Major');plot(256:256:256*256,mv_mkl_order1_dim1_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('MKl-Vector-Times-Matrix (CM) \pi=[1,2], m=1')


%%%%%%%%%%%%%%%%%%%%%%%

run('matrix_vector_order1_dim2');

mv_openblas_order1_dim2_flops=tlib_ttv_small_block_parallel_openblas_order1_dim2_ops./tlib_ttv_small_block_parallel_openblas_order1_dim2_time;
mv_openblas_order1_dim2_gflops=mv_openblas_order1_dim2_flops*10^-9;
figure('name','Openblas-Matrix-Vektor-Column-Major');plot(256:256:256*256,mv_openblas_order1_dim2_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Openblas-Matrix-Times-Vector (CM) \pi=[1,2], m=2')

mv_mkl_order1_dim2_flops=tlib_ttv_small_block_parallel_mkl_order1_dim2_ops./tlib_ttv_small_block_parallel_mkl_order1_dim2_time;
mv_mkl_order1_dim2_gflops=mv_mkl_order1_dim2_flops*10^-9;
figure('name','Mkl-Matrix-Vektor-Column-Major');plot(256:256:256*256,mv_mkl_order1_dim2_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Mkl-Matrix-Times-Vector (CM) \pi=[1,2], m=2')

%%%%%%%%%%%%%%%%%%%%%%%

run('matrix_vector_order2_dim1');

mv_openblas_order2_dim1_flops=tlib_ttv_small_block_parallel_openblas_order2_dim1_ops./tlib_ttv_small_block_parallel_openblas_order2_dim1_time;
mv_openblas_order2_dim1_gflops=mv_openblas_order2_dim1_flops*10^-9;
figure('name','Openblas-Vektor-Matrix-Row-Major');
plot(256:256:256*256,mv_openblas_order2_dim1_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Openblas-Matrix-Times-Vector (RM) \pi=[2,1], m=1')


mv_mkl_order2_dim1_flops=tlib_ttv_small_block_parallel_mkl_order2_dim1_ops./tlib_ttv_small_block_parallel_mkl_order2_dim1_time;
mv_mkl_order2_dim1_gflops=mv_mkl_order2_dim1_flops*10^-9;
figure('name','Mkl-Matrrix-Vector-Row-Major');
plot(256:256:256*256,mv_mkl_order2_dim1_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Mkl-Matrix-Times-Vector (RM) \pi=[2,1], m=1')


%%%%%%%%%%%%%%%%%%%%%%%

run('matrix_vector_order2_dim2');

mv_openblas_order2_dim2_flops=tlib_ttv_small_block_parallel_openblas_order2_dim2_ops./tlib_ttv_small_block_parallel_openblas_order2_dim2_time;
mv_openblas_order2_dim2_gflops=mv_openblas_order2_dim2_flops*10^-9;
figure('name','Openblas-Matrix-Vektor-Row-Major');plot(256:256:256*256,mv_openblas_order2_dim2_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('OpenBlas-Matrix-Times-Vector (RM) \pi=[2,1], m=2')

mv_mkl_order2_dim2_flops=tlib_ttv_small_block_parallel_mkl_order2_dim2_ops./tlib_ttv_small_block_parallel_mkl_order2_dim2_time;
mv_mkl_order2_dim2_gflops=mv_mkl_order2_dim2_flops*10^-9;
figure('name','Mkl-Matrix-Vektor-Row-Major');plot(256:256:256*256,mv_mkl_order2_dim2_gflops);
xlabel('Number of Rows'); 
ylabel('GFlops'); 
title('Mkl-Matrix-Times-Vector (RM) \pi=[2,1], m=2')


