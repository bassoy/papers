%analyze_algos_case8("icelake","symmetric","order1","rm")
function analyze_algos_case8(processor, shape, aformat, bformat)

  [tlib_gflops,tlib_times,sizes,gflops] = read_profile_data(processor, shape, aformat, bformat);

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

  tlib_threadedgemm_slice_gflops         = tlib_gflops(:,:,:,1);
  tlib_threadedgemm_subtensor_gflops     = tlib_gflops(:,:,:,2);
  tlib_ompforloop_slice_all_gflops       = tlib_gflops(:,:,:,3);
  tlib_ompforloop_subtensor_outer_gflops = tlib_gflops(:,:,:,4);
  tlib_optimized_gflops                  = tlib_gflops(:,:,:,5);
  tlib_bgemm_gflops                      = tlib_gflops(:,:,:,6);

  tlib_threadedgemm_slice_times         = tlib_times(:,:,:,1);
  tlib_threadedgemm_subtensor_times     = tlib_times(:,:,:,2);
  tlib_ompforloop_slice_all_times       = tlib_times(:,:,:,3);
  tlib_ompforloop_subtensor_outer_times = tlib_times(:,:,:,4);
  tlib_optimized_times                  = tlib_times(:,:,:,5);
  tlib_bgemm_times                      = tlib_times(:,:,:,6);


  %tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  %tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  %tlib_ompforloop_ratio   = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_ompforloop_subtensor_outer_times);
  %tlib_slice_ratio        = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_slice_times);
  %tlib_subtensor_ratio    = compute_ratio( tlib_ompforloop_subtensor_outer_times, tlib_threadedgemm_subtensor_times);
  %tlib_best_ratio         = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_subtensor_times); % tgemm_slice_vs_ompfor_subtensor

  [_,_,_,_,tlib_ompforloop_slice_all_gflops_d8]       = extractCases(tlib_ompforloop_slice_all_gflops);
  [_,_,_,_,tlib_ompforloop_subtensor_outer_gflops_d8] = extractCases(tlib_ompforloop_subtensor_outer_gflops);
  [_,_,_,_,tlib_threadedgemm_slice_gflops_d8]         = extractCases(tlib_threadedgemm_slice_gflops);
  [_,_,_,_,tlib_threadedgemm_subtensor_gflops_d8]     = extractCases(tlib_threadedgemm_subtensor_gflops);
  [_,_,_,_,tlib_optimized_gflops_d8]                  = extractCases(tlib_optimized_gflops);
  [_,_,_,_,tlib_bgemm_gflops_d8]                      = extractCases(tlib_bgemm_gflops);


  tlib_ompforloop_slice_all_gflops_mean_size = squeeze(mean(tlib_ompforloop_slice_all_gflops,2));
  tlib_ompforloop_slice_all_gflops_mean_size_cmode = squeeze(mean(tlib_ompforloop_slice_all_gflops_mean_size,2));

  tlib_ompforloop_subtensor_outer_gflops_mean_size = squeeze(mean(tlib_ompforloop_subtensor_outer_gflops,2));
  tlib_ompforloop_subtensor_outer_gflops_mean_size_cmode = squeeze(mean(tlib_ompforloop_subtensor_outer_gflops_mean_size,2));


  tlib_ompforloop_subtensor_outer_gflops_d8_per_core        = tlib_ompforloop_subtensor_outer_gflops_d8./cores;
  tlib_ompforloop_subtensor_outer_gflops_d8_max             = max   (tlib_ompforloop_subtensor_outer_gflops_d8(:))
  tlib_ompforloop_subtensor_outer_gflops_d8_mean            = mean  (tlib_ompforloop_subtensor_outer_gflops_d8(:))
  tlib_ompforloop_subtensor_outer_gflops_d8_median          = median(tlib_ompforloop_subtensor_outer_gflops_d8(:))
  tlib_ompforloop_subtensor_outer_gflops_d8_max_per_core    = max   (tlib_ompforloop_subtensor_outer_gflops_d8_per_core(:))
  tlib_ompforloop_subtensor_outer_gflops_d8_mean_per_core   = mean  (tlib_ompforloop_subtensor_outer_gflops_d8_per_core(:))
  tlib_ompforloop_subtensor_outer_gflops_d8_median_per_core = median(tlib_ompforloop_subtensor_outer_gflops_d8_per_core(:))

  tlib_ompforloop_slice_all_gflops_d8_per_core        = tlib_ompforloop_slice_all_gflops_d8./cores;
  tlib_ompforloop_slice_all_gflops_d8_max             = max   (tlib_ompforloop_slice_all_gflops_d8(:))
  tlib_ompforloop_slice_all_gflops_d8_mean            = mean  (tlib_ompforloop_slice_all_gflops_d8(:))
  tlib_ompforloop_slice_all_gflops_d8_median          = median(tlib_ompforloop_slice_all_gflops_d8(:))
  tlib_ompforloop_slice_all_gflops_d8_max_per_core    = max   (tlib_ompforloop_slice_all_gflops_d8_per_core(:))
  tlib_ompforloop_slice_all_gflops_d8_mean_per_core   = mean  (tlib_ompforloop_slice_all_gflops_d8_per_core(:))
  tlib_ompforloop_slice_all_gflops_d8_median_per_core = median(tlib_ompforloop_slice_all_gflops_d8_per_core(:))

  tlib_threadedgemm_subtensor_gflops_d8_per_core        = tlib_threadedgemm_subtensor_gflops_d8./cores;
  tlib_threadedgemm_subtensor_gflops_d8_max             = max   (tlib_threadedgemm_subtensor_gflops_d8(:))
  tlib_threadedgemm_subtensor_gflops_d8_mean            = mean  (tlib_threadedgemm_subtensor_gflops_d8(:))
  tlib_threadedgemm_subtensor_gflops_d8_median          = median(tlib_threadedgemm_subtensor_gflops_d8(:))
  tlib_threadedgemm_subtensor_gflops_d8_max_per_core    = max   (tlib_threadedgemm_subtensor_gflops_d8_per_core(:))
  tlib_threadedgemm_subtensor_gflops_d8_mean_per_core   = mean  (tlib_threadedgemm_subtensor_gflops_d8_per_core(:))
  tlib_threadedgemm_subtensor_gflops_d8_median_per_core = median(tlib_threadedgemm_subtensor_gflops_d8_per_core(:))

  tlib_threadedgemm_slice_gflops_d8_per_core        = tlib_threadedgemm_slice_gflops_d8./cores;
  tlib_threadedgemm_slice_gflops_d8_max             = max   (tlib_threadedgemm_slice_gflops_d8(:))
  tlib_threadedgemm_slice_gflops_d8_mean            = mean  (tlib_threadedgemm_slice_gflops_d8(:))
  tlib_threadedgemm_slice_gflops_d8_median          = median(tlib_threadedgemm_slice_gflops_d8(:))
  tlib_threadedgemm_slice_gflops_d8_max_per_core    = max   (tlib_threadedgemm_slice_gflops_d8_per_core(:))
  tlib_threadedgemm_slice_gflops_d8_mean_per_core   = mean  (tlib_threadedgemm_slice_gflops_d8_per_core(:))
  tlib_threadedgemm_slice_gflops_d8_median_per_core = median(tlib_threadedgemm_slice_gflops_d8_per_core(:))

  tlib_optimized_gflops_d8_per_core        = tlib_optimized_gflops_d8./cores;
  tlib_optimized_gflops_d8_max             = max   (tlib_optimized_gflops_d8(:))
  tlib_optimized_gflops_d8_mean            = mean  (tlib_optimized_gflops_d8(:))
  tlib_optimized_gflops_d8_median          = median(tlib_optimized_gflops_d8(:))
  tlib_optimized_gflops_d8_max_per_core    = max   (tlib_optimized_gflops_d8_per_core(:))
  tlib_optimized_gflops_d8_mean_per_core   = mean  (tlib_optimized_gflops_d8_per_core(:))
  tlib_optimized_gflops_d8_median_per_core = median(tlib_optimized_gflops_d8_per_core(:))

  tlib_bgemm_gflops_d8_per_core        = tlib_bgemm_gflops_d8./cores;
  tlib_bgemm_gflops_d8_max             = max   (tlib_bgemm_gflops_d8(:))
  tlib_bgemm_gflops_d8_mean            = mean  (tlib_bgemm_gflops_d8(:))
  tlib_bgemm_gflops_d8_median          = median(tlib_bgemm_gflops_d8(:))
  tlib_bgemm_gflops_d8_max_per_core    = max   (tlib_bgemm_gflops_d8_per_core(:))
  tlib_bgemm_gflops_d8_mean_per_core   = mean  (tlib_bgemm_gflops_d8_per_core(:))
  tlib_bgemm_gflops_d8_median_per_core = median(tlib_bgemm_gflops_d8_per_core(:))

  %tlib_ompforloop_slice_all_gflops_d8

  % if ratio > 1 => slice is faster
  % if ratio < 1 => subtensor is faster

  slice_subtensor_parloop_ratio_d8        = tlib_ompforloop_slice_all_gflops_d8./tlib_ompforloop_subtensor_outer_gflops_d8;
  slice_subtensor_parloop_ratio_d8_mean   = mean  (slice_subtensor_parloop_ratio_d8(:))
  slice_subtensor_parloop_ratio_d8_median = median(slice_subtensor_parloop_ratio_d8(:))

  subtensor_slice_pargemm_ratio_d8        = tlib_threadedgemm_subtensor_gflops_d8./tlib_threadedgemm_slice_gflops_d8;
  subtensor_slice_pargemm_ratio_d8_median = median(subtensor_slice_pargemm_ratio_d8(:))
  subtensor_slice_pargemm_ratio_d8_mean   = mean  (subtensor_slice_pargemm_ratio_d8(:))

  pargemm_parloop_slice_ratio_d8        = tlib_threadedgemm_slice_gflops_d8./tlib_ompforloop_slice_all_gflops_d8;
  pargemm_parloop_slice_ratio_d8_median = median(subtensor_slice_pargemm_ratio_d8(:))
  pargemm_parloop_slice_ratio_d8_mean   = mean  (subtensor_slice_pargemm_ratio_d8(:))

  pargemm_parloop_subtensor_ratio_d8        = tlib_threadedgemm_subtensor_gflops_d8./tlib_ompforloop_subtensor_outer_gflops_d8;
  pargemm_parloop_subtensor_ratio_d8_median = median(pargemm_parloop_subtensor_ratio_d8(:))
  pargemm_parloop_subtensor_ratio_d8_mean   = mean  (pargemm_parloop_subtensor_ratio_d8(:))


  optimized_bgemm_ratio_d8        = tlib_optimized_gflops_d8./tlib_bgemm_gflops_d8;
  optimized_bgemm_ratio_d8_median = median(optimized_bgemm_ratio_d8(:))
  optimized_bgemm_ratio_d8_mean   = mean  (optimized_bgemm_ratio_d8(:))

  bgemm_pargemm_subtensor_ratio_d8        = tlib_bgemm_gflops_d8./tlib_threadedgemm_subtensor_gflops_d8;
  bgemm_pargemm_subtensor_ratio_d8_median = median(bgemm_pargemm_subtensor_ratio_d8(:))
  bgemm_pargemm_subtensor_ratio_d8_mean   = mean  (bgemm_pargemm_subtensor_ratio_d8(:))

  bgemm_pargemm_slice_ratio_d8        = tlib_bgemm_gflops_d8./tlib_threadedgemm_slice_gflops_d8;
  bgemm_pargemm_slice_ratio_d8_median = median(bgemm_pargemm_slice_ratio_d8(:))
  bgemm_pargemm_slice_ratio_d8_mean   = mean  (bgemm_pargemm_slice_ratio_d8(:))

  bgemm_parloop_slice_ratio_d8        = tlib_bgemm_gflops_d8./tlib_ompforloop_slice_all_gflops_d8;
  bgemm_parloop_slice_ratio_d8_median = median(bgemm_parloop_slice_ratio_d8(:))
  bgemm_parloop_slice_ratio_d8_mean   = mean  (bgemm_parloop_slice_ratio_d8(:))

  %d = tlib_ompforloop_slice_all_gflops;
  %for p = 3:(size(d,1)+1) % order , p=3,...,7
  %  p
  %  for q = 2:(p-1) % c.mode , q=2
  %  q
  %  end
  %end

  % surf(optimized_bgemm_ratio_d8)


end

