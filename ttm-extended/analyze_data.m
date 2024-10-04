function analyze_data()

  shape="symmetric"
  #shape="nonsymmetric"


  folderin=['/home/bascem/Desktop/auswertung/files_profile/ttm/genoa/tlib/tensor/aocl/',shape,'/order1/cm/double'];

  cores=64;
  if strcmp(shape,"symmetric")
    modes=1:7;
    order=2:7;
  else
    modes=1:10;
    order=2:10;
  end



  tlib_threadedgemm_slice_gflops = [];
  tlib_threadedgemm_subtensor_gflops = [];
  tlib_ompforloop_slice_all_gflops = [];
  tlib_ompforloop_subtensor_outer_gflops = [];

  for k = modes
    script = cstrcat(folderin ,"/", "data_dim", num2str(k),".m");
    script
    run(script);
    gflops                               = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_ops" ));
    sizes                                = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_size"));
    tlib_threadedgemm_slice_time         = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_time"));
    tlib_threadedgemm_subtensor_time     = eval(cstrcat("tlib_threadedgemm_subtensor_dim",     num2str(k),"_time"));
    tlib_ompforloop_slice_all_time       = eval(cstrcat("tlib_ompforloop_slice_all_dim",       num2str(k),"_time"));
    tlib_ompforloop_subtensor_outer_time = eval(cstrcat("tlib_ompforloop_subtensor_outer_dim", num2str(k),"_time"));
    gflops *= 1e-9;

    tlib_threadedgemm_slice_times         (:,:,k) = tlib_threadedgemm_slice_time         ;
    tlib_threadedgemm_subtensor_times     (:,:,k) = tlib_threadedgemm_subtensor_time     ;
    tlib_ompforloop_slice_all_times       (:,:,k) = tlib_ompforloop_slice_all_time       ;
    tlib_ompforloop_subtensor_outer_times (:,:,k) = tlib_ompforloop_subtensor_outer_time ;

    tlib_threadedgemm_slice_gflops        (:,:,k) = gflops ./ tlib_threadedgemm_slice_time         ./cores;
    tlib_threadedgemm_subtensor_gflops    (:,:,k) = gflops ./ tlib_threadedgemm_subtensor_time     ./cores;
    tlib_ompforloop_slice_all_gflops      (:,:,k) = gflops ./ tlib_ompforloop_slice_all_time       ./cores;
    tlib_ompforloop_subtensor_outer_gflops(:,:,k) = gflops ./ tlib_ompforloop_subtensor_outer_time ./cores;
  end

  tlib_threadedgemm_ratio = compute_ratio( tlib_threadedgemm_slice_times,         tlib_threadedgemm_subtensor_times);
  tlib_ompforloop_ratio   = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_ompforloop_subtensor_outer_times);
  tlib_slice_ratio        = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_slice_times);
  tlib_subtensor_ratio    = compute_ratio( tlib_ompforloop_subtensor_outer_times, tlib_threadedgemm_subtensor_times);
  tlib_best_ratio         = compute_ratio( tlib_ompforloop_slice_all_times,       tlib_threadedgemm_subtensor_times); % tgemm_slice_vs_ompfor_subtensor

  [x, y] = meshgrid(order,sizes(1,:));

  tlib_ompforloop_subtensor_outer_gflops
  tlib_ompforloop_slice_all_gflops

  slice_subtensor_ratio = tlib_ompforloop_slice_all_gflops./tlib_ompforloop_subtensor_outer_gflops;

  less_than_one = slice_subtensor_ratio < 1;
  slice_subtensor_ratio(less_than_one) = -1./slice_subtensor_ratio(less_than_one);
  slice_subtensor_ratio



  %parloop_ratio_q3_p410 = tlib_ompforloop_ratio(3:9,:,3)
  %parloop_ratio_q4_p510 = tlib_ompforloop_ratio(4:9,:,4)
  %parloop_ratio_q5_p610 = tlib_ompforloop_ratio(5:9,:,5)
  %parloop_ratio_q6_p710 = tlib_ompforloop_ratio(6:9,:,6)
  %parloop_ratio_q7_p810 = tlib_ompforloop_ratio(7:9,:,7)
  %parloop_ratio_q8_p910 = tlib_ompforloop_ratio(8:9,:,8)

  %par_gemm_2d_q3_p47_gflops=tlib_threadedgemm_slice_gflops(3:6,:,3)
  %par_loop_2d_q3_p47_gflops=tlib_ompforloop_slice_all_gflops(3:6,:,3)
  %ratio_2d_q3_p47 = tlib_slice_ratio(3:6,:,3)

  %par_gemm_2d_q4_p57_gflops=tlib_threadedgemm_slice_gflops(4:6,:,4)
  %par_loop_2d_q4_p57_gflops=tlib_ompforloop_slice_all_gflops(4:6,:,4)
  %ratio_2d_q4_p57 = tlib_slice_ratio(4:6,:,4)

  %par_gemm_2d_q5_p67_gflops=tlib_threadedgemm_slice_gflops(5:6,:,5)
  %par_loop_2d_q5_p67_gflops=tlib_ompforloop_slice_all_gflops(5:6,:,5)
  %ratio_2d_q5_p67 = tlib_slice_ratio(5:6,:,5)

  %par_gemm_2d_q6_p7_gflops=tlib_threadedgemm_slice_gflops(6,:,6)
  %par_loop_2d_q6_p7_gflops=tlib_ompforloop_slice_all_gflops(6,:,6)
  %ratio_2d_q6_p7 = tlib_slice_ratio(6,:,6)

  close all
  cmap = jet();
  %plot_scatter_gflops(modes, x, y, cmap, tlib_threadedgemm_slice_gflops,         'SeqLoop-ParGemm-2D');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_threadedgemm_subtensor_gflops,     'SeqLoop-ParGemm-qD');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_ompforloop_slice_all_gflops,       'ParLoop-SeqGemm-2D');
  %plot_scatter_gflops(modes, x, y, cmap, tlib_ompforloop_subtensor_outer_gflops, 'ParLoop-SeqGemm-qD');

  cmap = get_cmap();
  plot_scatter_ratio(modes, x, y, cmap, tlib_threadedgemm_ratio, ['Comparison of par-gemm (2D vs. qD) with ',shape,' shapes.']);
  plot_scatter_ratio(modes, x, y, cmap, tlib_ompforloop_ratio,   ['Comparison of par-loop (2D vs. qD) with ',shape,' shapes.']);
  plot_scatter_ratio(modes, x, y, cmap, tlib_slice_ratio,        ['Comparison of slice-2D (par-loop vs. par-gemm) with ',shape,' shapes.']);
  plot_scatter_ratio(modes, x, y, cmap, tlib_subtensor_ratio,    ['Comparison of slice-qD (par-loop vs. par-gemm) with ',shape,' shapes.']);
  plot_scatter_ratio(modes, x, y, cmap, tlib_best_ratio,         ['Comparison of par-loop-slice-2D vs. par-gemm-slice-qD with ',shape,' shapes.']);

  %plot_histogram(modes, tlib_threadedgemm_ratio, 'Comparison of par-gemm (2D vs. qD)');
  %plot_histogram(modes, tlib_ompforloop_ratio,   'Comparison of par-loop (2D vs. qD)');
  %plot_histogram(modes, tlib_slice_ratio,        'Comparison of slice-2D (par-loop vs. par-gemm)');
  %plot_histogram(modes, tlib_subtensor_ratio,    'Comparison of slice-qD (par-loop vs. par-gemm)');


end


function ratio_new = compute_ratio(nom, denom)
  ratio  = nom  ./ denom;
  less_than_one = ratio<1;
  greater_than_one = ratio>1;
  ratio_new = zeros(size(ratio));
  ratio_new(less_than_one) = (1./ratio(less_than_one));
  ratio_new(greater_than_one) = -ratio(greater_than_one);
end

function plot_scatter_gflops(modes, x, y, cmap, gflops, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    g = gflops(:,:,i)';
    scatter(y(:), x(:),50, g(:),'filled');
    ylabel('Tensor Order');
    xlabel('Tensor Size');
    title(['C.mode q=', num2str(i)]);
    colormap(cmap);
    caxis([0, 50]);
    hcb = colorbar;
    title(hcb, 'Gflops');
  end
end


function plot_scatter_ratio(modes, x, y, cmap, ratio, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    r = ratio(:,:,i)';
    absr = abs(r(:));
    relr = 100 * absr./max(absr);
    scatter(y,x,100,r(:),'filled');
    ylabel('Tensor Order');
    xlabel('Tensor Size');
    title(['Contraction mode q=', num2str(i)]);
    colormap(cmap);
    caxis([-10 10]);
    ylim([x(1)-1 x(end)+1]);
    yticks((x(1)-1):x(end));
    yticklabels(num2cell(yticks));
    hcb = colorbar;
    title(hcb, '[%]');

  end
end

function plot_histogram(modes, ratio, figure_name)
  figure('Name',figure_name);
  for i = modes
    subplot(2, 5, i);
    r = ratio(:,:,i);
    hist(r(:),20);
    xlabel('Ratio');
    ylabel('Occurences');
    title(['Contraction mode q=', num2str(i)]);
  end
end

function cmap = get_cmap()
  colors = [
    0, 0, 77;       % Deep Blue (Darkest)
    0, 0, 102;      % Navy Blue
    0, 0, 128;      % Dark Blue
    0, 0, 153;      % Sapphire Blue
    0, 0, 204;      % True Blue
    0, 0, 255;      % Pure Blue
    51, 51, 255;    % Bright Blue
    77, 77, 255;    % Vivid Blue
    102, 102, 255;  % Sky Blue
    %128, 128, 255   % Light Blue (Lightest)
    211, 211, 211;   % gray
    211, 211, 211;   % gray
    %255, 102, 102;   % Light Red
    255, 77, 77;     % Bright Red
    255, 51, 51;     % Scarlet
    255, 26, 26;     % Cherry Red
    255, 0, 0;       % Pure Red
    204, 0, 0;       % Dark Red
    153, 0, 0;       % Crimson
    128, 0, 0;       % Burgundy
    102, 0, 0;       % Wine
    77, 0, 0        % Deep Red
  ] ./ 255;  % Normalize to [0, 1]
  ncolors=size(colors,1);
  onecolor=100;
  cmap = zeros(onecolor*ncolors,3);

  k=1:onecolor;
  for i=1:ncolors
    b = (i-1)*onecolor;
    cmap(b+k,:) = repmat(colors(i,:),onecolor, 1);
  end

  b = (9-1)*onecolor;
  k=1:90;  cmap(b+k,:) = repmat(colors( 9,:),k(end), 1); b+=k(end);
  k=1:110; cmap(b+k,:) = repmat(colors(10,:),k(end), 1); b+=k(end);
  k=1:110; cmap(b+k,:) = repmat(colors(11,:),k(end), 1); b+=k(end);
  k=1:90;  cmap(b+k,:) = repmat(colors(12,:),k(end), 1);

end
