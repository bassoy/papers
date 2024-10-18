%analyze_matrix_ordering("icelake","symmetric","order1")
function analyze_matrix_ordering(processor, shape, aformat)

  [tlib_gflops_rm,tlib_times_rm,sizes,gflops] = read_profile_data(processor, shape, aformat, "rm");
  [tlib_gflops_cm,tlib_times_cm,sizes,gflops] = read_profile_data(processor, shape, aformat, "cm");

  if strcmp(shape,"symmetric")
    modes=1:7;
    order=2:7;
  else
    modes=1:10;
    order=2:10;
  end

  if (strcmp(processor,"icelake"))
    blas="mkl";
    cores=48;
  else
    blas="aocl";
    cores=64;
  end

  tlib_threadedgemm_slice_times_rm         = tlib_times_rm(:,:,:,1);
  tlib_threadedgemm_subtensor_times_rm     = tlib_times_rm(:,:,:,2);
  tlib_ompforloop_slice_all_times_rm       = tlib_times_rm(:,:,:,3);
  tlib_ompforloop_subtensor_outer_times_rm = tlib_times_rm(:,:,:,4);
  tlib_optimized_times_rm                  = tlib_times_rm(:,:,:,5);

  tlib_threadedgemm_slice_times_cm         = tlib_times_cm(:,:,:,1);
  tlib_threadedgemm_subtensor_times_cm     = tlib_times_cm(:,:,:,2);
  tlib_ompforloop_slice_all_times_cm       = tlib_times_cm(:,:,:,3);
  tlib_ompforloop_subtensor_outer_times_cm = tlib_times_cm(:,:,:,4);
  tlib_optimized_times_cm                  = tlib_times_cm(:,:,:,5);

  for i=1:size(tlib_gflops_cm,4)
    [_,_,_,_,tlib_gflops_rm_d8(:,:,i)]       = extractCases(tlib_gflops_rm(:,:,:,i));
    [_,_,_,_,tlib_gflops_cm_d8(:,:,i)]       = extractCases(tlib_gflops_cm(:,:,:,i));

  end

  for i=1:size(tlib_gflops_rm_d8,3)
    gflops_rm_d8 = tlib_gflops_rm_d8(:,:,i);
    gflops_cm_d8 = tlib_gflops_cm_d8(:,:,i);

    tlib_gflops_rm_d8_normalized = (gflops_rm_d8 - mean(gflops_rm_d8(:))) / std(gflops_rm_d8(:));
    tlib_gflops_cm_d8_normalized = (gflops_cm_d8 - mean(gflops_cm_d8(:))) / std(gflops_cm_d8(:));

    % Calculate Euclidean distance on the standardized data
    distance = norm(tlib_gflops_rm_d8_normalized - tlib_gflops_cm_d8_normalized);
    num_elems = numel(gflops_rm_d8(:));

    [ss_rm_d8, iqrd_rm_d8] = getStatistics(gflops_rm_d8(:), 2, 2);
    [ss_cm_d8, iqrd_cm_d8] = getStatistics(gflops_cm_d8(:), 2, 2);


    median_rm_d8         = ss_rm_d8(3);
    median_cm_d8         = ss_cm_d8(3);

    median_rel_error     = 100*(abs(median_rm_d8-median_cm_d8)/mean([median_rm_d8,median_cm_d8]));

    lower_quartile_rm_d8 = ss_rm_d8(2);
    lower_quartile_cm_d8 = ss_cm_d8(2);

    lower_quartile_rel_error = 100*(abs(lower_quartile_rm_d8-lower_quartile_cm_d8)/...
                                             mean([lower_quartile_rm_d8,lower_quartile_cm_d8]));

    upper_quartile_rm_d8 = ss_rm_d8(4);
    upper_quartile_cm_d8 = ss_cm_d8(4);

    upper_quartile_rel_error = 100*(abs(upper_quartile_rm_d8-upper_quartile_cm_d8)/...
                                             mean([upper_quartile_rm_d8,upper_quartile_cm_d8]));

    disp(['Percentage difference in [\%] of the median: ', num2str(median_rel_error), ' of the lower quartile: ',  num2str(lower_quartile_rel_error), ' and of the upper quartile: ',  num2str(upper_quartile_rel_error) ]);
    disp(['Standardized Euclidean Distance: ', num2str(distance), ' with ',  num2str(num_elems), ' elements and min/max dissimilarity of (0,', num2str(sqrt(num_elems)) ,')'] ) ;
    disp('');
  end


end

