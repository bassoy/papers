%analyze_algos("icelake","symmetric","order1","rm")
function analyze_algos(processor, shape, aformat, bformat)

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


  tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  tlib_ompforloop_ratio   = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_ompforloop_subtensor_outer_times);
  tlib_slice_ratio        = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_slice_times);
  tlib_subtensor_ratio    = compute_ratio( tlib_ompforloop_subtensor_outer_times, tlib_threadedgemm_subtensor_times);
  tlib_best_ratio         = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_subtensor_times); % tgemm_slice_vs_ompfor_subtensor

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

  %plot(tlib_ompforloop_slice_all_gflops_mean_size(:,6))
  %plot(tlib_ompforloop_slice_all_gflops_mean_size_cmode)
%{
  order = 2:7;
  x = order;
  %y = tlib_ompforloop_slice_all_gflops_mean_size_cmode;
  y = tlib_ompforloop_subtensor_outer_gflops_mean_size_cmode;
  degree = 3;
  p = polyfit(x, y, degree);
  x_fit = linspace(min(x), max(x), 10);
  y_fit = polyval(p, x_fit);
  p
  plot(x, y, '--ob', x_fit, y_fit, '-xr');
  return
%}

  tlib_ompforloop_subtensor_outer_gflops_per_core        = tlib_ompforloop_subtensor_outer_gflops./cores;
  tlib_ompforloop_subtensor_outer_gflops_max             = max   (tlib_ompforloop_subtensor_outer_gflops(:))
  tlib_ompforloop_subtensor_outer_gflops_mean            = mean  (tlib_ompforloop_subtensor_outer_gflops(:))
  tlib_ompforloop_subtensor_outer_gflops_median          = median(tlib_ompforloop_subtensor_outer_gflops(:))
  tlib_ompforloop_subtensor_outer_gflops_max_per_core    = max   (tlib_ompforloop_subtensor_outer_gflops_per_core(:))
  tlib_ompforloop_subtensor_outer_gflops_mean_per_core   = mean  (tlib_ompforloop_subtensor_outer_gflops_per_core(:))
  tlib_ompforloop_subtensor_outer_gflops_median_per_core = median(tlib_ompforloop_subtensor_outer_gflops_per_core(:))

  tlib_ompforloop_slice_all_gflops_per_core        = tlib_ompforloop_slice_all_gflops./cores;
  tlib_ompforloop_slice_all_gflops_max             = max   (tlib_ompforloop_slice_all_gflops(:))
  tlib_ompforloop_slice_all_gflops_mean            = mean  (tlib_ompforloop_slice_all_gflops(:))
  tlib_ompforloop_slice_all_gflops_median          = median(tlib_ompforloop_slice_all_gflops(:))
  tlib_ompforloop_slice_all_gflops_max_per_core    = max   (tlib_ompforloop_slice_all_gflops_per_core(:))
  tlib_ompforloop_slice_all_gflops_mean_per_core   = mean  (tlib_ompforloop_slice_all_gflops_per_core(:))
  tlib_ompforloop_slice_all_gflops_median_per_core = median(tlib_ompforloop_slice_all_gflops_per_core(:))

  tlib_threadedgemm_subtensor_gflops_per_core        = tlib_threadedgemm_subtensor_gflops./cores;
  tlib_threadedgemm_subtensor_gflops_max             = max   (tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_mean            = mean  (tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_median          = median(tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_max_per_core    = max   (tlib_threadedgemm_subtensor_gflops_per_core(:))
  tlib_threadedgemm_subtensor_gflops_mean_per_core   = mean  (tlib_threadedgemm_subtensor_gflops_per_core(:))
  tlib_threadedgemm_subtensor_gflops_median_per_core = median(tlib_threadedgemm_subtensor_gflops_per_core(:))

  tlib_threadedgemm_slice_gflops_per_core        = tlib_threadedgemm_slice_gflops./cores;
  tlib_threadedgemm_slice_gflops_max             = max   (tlib_threadedgemm_slice_gflops(:))
  tlib_threadedgemm_slice_gflops_mean            = mean  (tlib_threadedgemm_slice_gflops(:))
  tlib_threadedgemm_slice_gflops_median          = median(tlib_threadedgemm_slice_gflops(:))
  tlib_threadedgemm_slice_gflops_max_per_core    = max   (tlib_threadedgemm_slice_gflops_per_core(:))
  tlib_threadedgemm_slice_gflops_mean_per_core   = mean  (tlib_threadedgemm_slice_gflops_per_core(:))
  tlib_threadedgemm_slice_gflops_median_per_core = median(tlib_threadedgemm_slice_gflops_per_core(:))

  tlib_optimized_gflops_per_core        = tlib_optimized_gflops./cores;
  tlib_optimized_gflops_max             = max   (tlib_optimized_gflops(:))
  tlib_optimized_gflops_mean            = mean  (tlib_optimized_gflops(:))
  tlib_optimized_gflops_median          = median(tlib_optimized_gflops(:))
  tlib_optimized_gflops_max_per_core    = max   (tlib_optimized_gflops_per_core(:))
  tlib_optimized_gflops_mean_per_core   = mean  (tlib_optimized_gflops_per_core(:))
  tlib_optimized_gflops_median_per_core = median(tlib_optimized_gflops_per_core(:))

  tlib_bgemm_gflops_per_core        = tlib_bgemm_gflops./cores;
  tlib_bgemm_gflops_max             = max   (tlib_bgemm_gflops(:))
  tlib_bgemm_gflops_mean            = mean  (tlib_bgemm_gflops(:))
  tlib_bgemm_gflops_median          = median(tlib_bgemm_gflops(:))
  tlib_bgemm_gflops_max_per_core    = max   (tlib_bgemm_gflops_per_core(:))
  tlib_bgemm_gflops_mean_per_core   = mean  (tlib_bgemm_gflops_per_core(:))
  tlib_bgemm_gflops_median_per_core = median(tlib_bgemm_gflops_per_core(:))

  %tlib_ompforloop_slice_all_gflops

  % if ratio > 1 => slice is faster
  % if ratio < 1 => subtensor is faster
  slice_subtensor_parloop_ratio        = tlib_ompforloop_slice_all_gflops./tlib_ompforloop_subtensor_outer_gflops;
  slice_subtensor_parloop_ratio_median = median(slice_subtensor_parloop_ratio(:))
  slice_subtensor_parloop_ratio_mean   = mean  (slice_subtensor_parloop_ratio(:))

  %subtensor_slice_ratio        = tlib_ompforloop_subtensor_outer_gflops./tlib_ompforloop_slice_all_gflops;
  %subtensor_slice_ratio_median = median(subtensor_slice_ratio(:))
  %subtensor_slice_ratio_mean   = mean(subtensor_slice_ratio(:))

  slice_subtensor_parloop_ratio_d8        = tlib_ompforloop_slice_all_gflops_d8./tlib_ompforloop_subtensor_outer_gflops_d8;
  slice_subtensor_parloop_ratio_d8_mean   = mean  (slice_subtensor_parloop_ratio_d8(:))
  slice_subtensor_parloop_ratio_d8_median = median(slice_subtensor_parloop_ratio_d8(:))

  %subtensor_slice_ratio_d8        = tlib_ompforloop_subtensor_outer_gflops_d8./tlib_ompforloop_slice_gflops_d8;
  %subtensor_slice_ratio_d8_mean   = mean  (subtensor_slice_ratio_d8(:))
  %subtensor_slice_ratio_d8_median = median(subtensor_slice_ratio_d8(:))

  %slice_subtensor_pargemm_ratio        = tlib_threadedgemm_slice_gflops./tlib_threadedgemm_subtensor_gflops;
  %slice_subtensor_pargemm_ratio_median = median(slice_subtensor_pargemm_ratio(:))
  %slice_subtensor_pargemm_ratio_mean   = mean  (slice_subtensor_pargemm_ratio(:))

  subtensor_slice_pargemm_ratio        = tlib_threadedgemm_subtensor_gflops./tlib_threadedgemm_slice_gflops;
  subtensor_slice_pargemm_ratio_median = median(subtensor_slice_pargemm_ratio(:))
  subtensor_slice_pargemm_ratio_mean   = mean  (subtensor_slice_pargemm_ratio(:))

  subtensor_slice_pargemm_ratio_d8        = tlib_threadedgemm_subtensor_gflops_d8./tlib_threadedgemm_slice_gflops_d8;
  subtensor_slice_pargemm_ratio_d8_median = median(subtensor_slice_pargemm_ratio_d8(:))
  subtensor_slice_pargemm_ratio_d8_mean   = mean  (subtensor_slice_pargemm_ratio_d8(:))

  pargemm_parloop_slice_ratio        = tlib_threadedgemm_slice_gflops./tlib_ompforloop_slice_all_gflops;
  pargemm_parloop_slice_ratio_median = median(pargemm_parloop_slice_ratio(:))
  pargemm_parloop_slice_ratio_mean   = mean  (pargemm_parloop_slice_ratio(:))

  pargemm_parloop_slice_ratio_d8        = tlib_threadedgemm_slice_gflops_d8./tlib_ompforloop_slice_all_gflops_d8;
  pargemm_parloop_slice_ratio_d8_median = median(subtensor_slice_pargemm_ratio_d8(:))
  pargemm_parloop_slice_ratio_d8_mean   = mean  (subtensor_slice_pargemm_ratio_d8(:))

  pargemm_parloop_subtensor_ratio        = tlib_threadedgemm_subtensor_gflops./tlib_ompforloop_subtensor_outer_gflops;
  pargemm_parloop_subtensor_ratio_median = median(pargemm_parloop_subtensor_ratio(:))
  pargemm_parloop_subtensor_ratio_mean   = mean  (pargemm_parloop_subtensor_ratio(:))

  pargemm_parloop_subtensor_ratio_d8        = tlib_threadedgemm_subtensor_gflops_d8./tlib_ompforloop_subtensor_outer_gflops_d8;
  pargemm_parloop_subtensor_ratio_d8_median = median(pargemm_parloop_subtensor_ratio_d8(:))
  pargemm_parloop_subtensor_ratio_d8_mean   = mean  (pargemm_parloop_subtensor_ratio_d8(:))

  %pargemm_slice_parloop_subtensor_ratio        = tlib_threadedgemm_slice_gflops./tlib_ompforloop_subtensor_outer_gflops;
  %pargemm_slice_parloop_subtensor_ratio_median = median(pargemm_slice_parloop_subtensor_ratio(:))
  %pargemm_slice_parloop_subtensor_ratio_mean   = mean  (pargemm_slice_parloop_subtensor_ratio(:))

  %pargemm_slice_parloop_subtensor_ratio_d8        = tlib_threadedgemm_slice_gflops_d8./tlib_ompforloop_subtensor_outer_gflops_d8;
  %pargemm_slice_parloop_subtensor_ratio_d8_median = median(pargemm_slice_parloop_subtensor_ratio_d8(:))
  %pargemm_slice_parloop_subtensor_ratio_d8_mean   = mean  (pargemm_slice_parloop_subtensor_ratio_d8(:))

end

