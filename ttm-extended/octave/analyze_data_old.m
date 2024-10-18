%analyze_data("icelake","symmetric","order1","rm")
function analyze_data(processor, shape, aformat, bformat)

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

  tlib_threadedgemm_slice_times         = tlib_times(:,:,:,1);
  tlib_threadedgemm_subtensor_times     = tlib_times(:,:,:,2);
  tlib_ompforloop_slice_all_times       = tlib_times(:,:,:,3);
  tlib_ompforloop_subtensor_outer_times = tlib_times(:,:,:,4);
  tlib_optimized_times                  = tlib_times(:,:,:,5);


  tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  tlib_ompforloop_ratio   = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_ompforloop_subtensor_outer_times);
  tlib_slice_ratio        = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_slice_times);
  tlib_subtensor_ratio    = compute_ratio( tlib_ompforloop_subtensor_outer_times, tlib_threadedgemm_subtensor_times);
  tlib_best_ratio         = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_subtensor_times); % tgemm_slice_vs_ompfor_subtensor

  [_,_,_,_,tlib_ompforloop_slice_all_gflops_d8]       = extractCases(tlib_ompforloop_slice_all_gflops);
  [_,_,_,_,tlib_ompforloop_subtensor_outer_gflops_d8] = extractCases(tlib_ompforloop_subtensor_outer_gflops);
  [_,_,_,_,tlib_threadedgemm_slice_gflops_d8]         = extractCases(tlib_threadedgemm_slice_gflops);
  [_,_,_,_,tlib_threadedgemm_subtensor_gflops_d8]     = extractCases(tlib_threadedgemm_subtensor_gflops);


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


  pargemm_parloop_slice_ratio          = tlib_threadedgemm_slice_gflops./tlib_ompforloop_slice_all_gflops;
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




  %less_than_one = slice_subtensor_ratio < 1;
  %slice_subtensor_ratio(less_than_one) = -1./slice_subtensor_ratio(less_than_one);

  %[x, y] = meshgrid(order,sizes(1,:));


  %close all
  %cmap = jet();
  %plot_scatter_gflops(modes, x, y, cmap, tlib_threadedgemm_slice_gflops,         'SeqLoop-ParGemm-2D');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_threadedgemm_subtensor_gflops,     'SeqLoop-ParGemm-qD');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_ompforloop_slice_all_gflops,       'ParLoop-SeqGemm-2D');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_ompforloop_subtensor_outer_gflops, 'ParLoop-SeqGemm-qD');

  %cmap = get_cmap();
  %plot_scatter_ratio(modes, x, y, cmap, tlib_threadedgemm_ratio, ['Comparison of par-gemm (2D vs. qD) with ',shape,' shapes.']);
  %plot_scatter_ratio(modes, x, y, cmap, tlib_ompforloop_ratio,   ['Comparison of par-loop (2D vs. qD) with ',shape,' shapes.']);
  %plot_scatter_ratio(modes, x, y, cmap, tlib_slice_ratio,        ['Comparison of slice-2D (par-loop vs. par-gemm) with ',shape,' shapes.']);
  %plot_scatter_ratio(modes, x, y, cmap, tlib_subtensor_ratio,    ['Comparison of slice-qD (par-loop vs. par-gemm) with ',shape,' shapes.']);
  %plot_scatter_ratio(modes, x, y, cmap, tlib_best_ratio,         ['Comparison of par-loop-slice-2D vs. par-gemm-slice-qD with ',shape,' shapes.']);

  %plot_histogram(modes, tlib_threadedgemm_ratio, 'Comparison of par-gemm (2D vs. qD)');
  %plot_histogram(modes, tlib_ompforloop_ratio,   'Comparison of par-loop (2D vs. qD)');
  %plot_histogram(modes, tlib_slice_ratio,        'Comparison of slice-2D (par-loop vs. par-gemm)');
  %plot_histogram(modes, tlib_subtensor_ratio,    'Comparison of slice-qD (par-loop vs. par-gemm)');


end

