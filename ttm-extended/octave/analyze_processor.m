%analyze_processor("symmetric","order1","rm")
function analyze_processor(shape, aformat,bformat)

  [tlib_gflops_intel,tlib_times_intel,sizes,gflops] = read_profile_data("icelake", shape, aformat, bformat);
  [tlib_gflops_amd,tlib_times_amd,sizes,gflops]     = read_profile_data("genoa",   shape, aformat, bformat);

  if strcmp(shape,"symmetric")
    modes=1:7;
    order=2:7;
  else
    modes=1:10;
    order=2:10;
  end

  cores_intel=48;
  cores_amd=64;

  impls = {...
    "tlib_threadedgemm_slice",
    "tlib_threadedgemm_subtensor",
    "tlib_ompforloop_slice",
    "tlib_ompforloop_subtensor",
    "tlib_optimized",
    "tlib_bgemm",
  };

  num_ipmls = size(tlib_gflops_amd,4);

  for i=1:num_ipmls
    [_,_,_,_,tlib_gflops_intel_d8(:,:,i)]     = extractCases(tlib_gflops_intel(:,:,:,i));
    [_,_,_,_,tlib_gflops_amd_d8(:,:,i)]       = extractCases(tlib_gflops_amd(:,:,:,i));
  end


  mean_ratios = [];
  mean_ratios_d8 = [];

  median_ratios = [];
  median_ratios_d8 = [];

  for i=1:num_ipmls
    implementation = impls{i}

    gflops_intel_d8 = tlib_gflops_intel_d8(:,:,i);
    gflops_amd_d8 = tlib_gflops_amd_d8(:,:,i);

    gflops_cores_intel = tlib_gflops_intel(:,:,:,i)./cores_intel;
    gflops_cores_amd = tlib_gflops_amd(:,:,:,i)./cores_amd;

    gflops_cores_intel_d8 = tlib_gflops_intel_d8(:,:,i)./cores_intel;
    gflops_cores_amd_d8 = tlib_gflops_amd_d8(:,:,i)./cores_amd;

    ratio_intel_amd_d8 = gflops_cores_intel_d8./gflops_cores_amd_d8;
    ratio_intel_amd_d8_mean = mean(gflops_cores_intel_d8(:)./gflops_cores_amd_d8(:));
    ratio_intel_amd_d8_median = median(gflops_cores_intel_d8(:)./gflops_cores_amd_d8(:));

    ratio_intel_amd = gflops_cores_intel./gflops_cores_amd;
    ratio_intel_amd_mean = mean(gflops_cores_intel(:)./gflops_cores_amd(:));
    ratio_intel_amd_median = median(gflops_cores_intel(:)./gflops_cores_amd(:));

    if ( ! strcmp(implementation,"tlib_bgemm") )
    mean_ratios = [mean_ratios, ratio_intel_amd_mean];
    mean_ratios_d8 = [mean_ratios_d8, ratio_intel_amd_d8_mean];

    median_ratios = [median_ratios, ratio_intel_amd_median];
    median_ratios_d8 = [median_ratios_d8, ratio_intel_amd_d8_median];
    end

    [ss_intel_d8, iqrd_intel_d8] = getStatistics(gflops_cores_intel_d8(:), 2, 2);
    [ss_amd_d8, iqrd_amd_d8] = getStatistics(gflops_cores_amd_d8(:), 2, 2);

    median_intel_d8       = ss_intel_d8(3);
    median_amd_d8         = ss_amd_d8(3);

    %median_rel_error     = 100*(abs(median_intel_d8-median_amd_d8)/mean([median_intel_d8,median_amd_d8]));

    lower_quartile_intel_d8 = ss_intel_d8(2);
    lower_quartile_amd_d8 = ss_amd_d8(2);

%lower_quartile_rel_error = 100*(abs(lower_quartile_intel_d8-lower_quartile_amd_d8)/...
                                             %mean([lower_quartile_intel_d8,lower_quartile_amd_d8]));

    upper_quartile_intel_d8 = ss_intel_d8(4);
    upper_quartile_amd_d8 = ss_amd_d8(4);

    %upper_quartile_rel_error = 100*(abs(upper_quartile_intel_d8-upper_quartile_amd_d8)/...
                                             %mean([upper_quartile_intel_d8,upper_quartile_amd_d8]));


    disp(['Computing the difference between processor types of method ' impls{i}]);
    if ( ! strcmp(implementation,"tlib_bgemm") )
      disp(['Ratio between Intel and Amd processor all cases: mean=', num2str(ratio_intel_amd_mean), ' median=' num2str(ratio_intel_amd_median)]);
      disp(['Ratio between Intel and Amd processor for case 8: mean=', num2str(ratio_intel_amd_d8_mean), ' median=' num2str(ratio_intel_amd_d8_median)]);
    end
    disp(['Statistics Intel (LQR,Median,UQR) for case 8: ', num2str(lower_quartile_intel_d8), ',', num2str(median_intel_d8), ',', num2str(upper_quartile_intel_d8) ]);
    if ( ! strcmp(implementation,"tlib_bgemm") )
      disp(['Statistics Amd (LQR,Median,UQR) for case 8: ', num2str(lower_quartile_amd_d8), ',', num2str(median_amd_d8), ',', num2str(upper_quartile_amd_d8) ]);
    end
    disp('');
  end

  mean_ratios
  mean_ratios_d8

  median_ratios
  median_ratios_d8
end

