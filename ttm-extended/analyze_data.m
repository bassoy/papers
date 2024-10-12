function analyze_data()

  processor="icelake"
  # processor="genoa"
  shape="symmetric"
  #shape="nonsymmetric"
  aformat="order1"
  bformat="rm"

  if (strcmp(processor,"icelake"))
    blas="mkl";
  else
    blas="aocl	";
  end




  folderin=['/home/bascem/Desktop/auswertung/files_profile/ttm/',processor,'/tlib/tensor/',blas,'/',shape,'/',aformat,'/',bformat,'/','double'];

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
    run(script);
    gflops                               = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_ops" ));
    sizes                                = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_size")); % order x size
    tlib_threadedgemm_slice_time         = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_time"));
    tlib_threadedgemm_subtensor_time     = eval(cstrcat("tlib_threadedgemm_subtensor_dim",     num2str(k),"_time"));
    tlib_ompforloop_slice_all_time       = eval(cstrcat("tlib_ompforloop_slice_all_dim",       num2str(k),"_time"));
    tlib_ompforloop_subtensor_outer_time = eval(cstrcat("tlib_ompforloop_subtensor_outer_dim", num2str(k),"_time"));
    gflops *= 1e-9;

    tlib_threadedgemm_slice_times         (:,:,k) = tlib_threadedgemm_slice_time         ;
    tlib_threadedgemm_subtensor_times     (:,:,k) = tlib_threadedgemm_subtensor_time     ;
    tlib_ompforloop_slice_all_times       (:,:,k) = tlib_ompforloop_slice_all_time       ;
    tlib_ompforloop_subtensor_outer_times (:,:,k) = tlib_ompforloop_subtensor_outer_time ;

    tlib_threadedgemm_slice_gflops        (:,:,k) = gflops ./ tlib_threadedgemm_slice_time         ;
    tlib_threadedgemm_subtensor_gflops    (:,:,k) = gflops ./ tlib_threadedgemm_subtensor_time     ;
    tlib_ompforloop_slice_all_gflops      (:,:,k) = gflops ./ tlib_ompforloop_slice_all_time       ;
    tlib_ompforloop_subtensor_outer_gflops(:,:,k) = gflops ./ tlib_ompforloop_subtensor_outer_time ;
  end

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
  [x, y] = meshgrid(order,sizes(1,:));

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


  tlib_threadedgemm_subtensor_gflops_per_core        = tlib_threadedgemm_subtensor_gflops./cores
  tlib_threadedgemm_subtensor_gflops_max             = max   (tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_mean            = mean  (tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_median          = median(tlib_threadedgemm_subtensor_gflops(:))
  tlib_threadedgemm_subtensor_gflops_max_per_core    = max   (tlib_threadedgemm_subtensor_gflops_per_core(:))
  tlib_threadedgemm_subtensor_gflops_mean_per_core   = mean  (tlib_threadedgemm_subtensor_gflops_per_core(:))
  tlib_threadedgemm_subtensor_gflops_median_per_core = median(tlib_threadedgemm_subtensor_gflops_per_core(:))

  tlib_threadedgemm_slice_gflops_per_core        = tlib_threadedgemm_slice_gflops./cores
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

  subtensor_slice_pargemm_ratio        = tlib_threadedgemm_subtensor_gflops./tlib_threadedgemm_slice_gflops
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



% dataY = order x size x modes
function [d2,d3,d6,d7,d8] = extractCases(dataY)
  % order x size x mode
  d  = squeeze(dataY(:,:,:));
  %size(d)
  d2 = squeeze(d(1    ,:,1    )); % p=2, q=1
  d3 = squeeze(d(1    ,:,2:end)); % p=2, q=2,...,p
  d6 = squeeze(d(2:end,:,1    )); % p>2, q=1
  d7 = [];
  d8 = [];
  for p = 3:(size(d,1)+1) % order
    for q = p:size(d,3) % c.mode
      d7 = [d7;d(p-1,:,q)]; % p>2, q=p
    end
  end
  for p = 3:(size(d,1)+1) % order , p=3,...,7
    for q = 2:(p-1) % c.mode , q=2
      d8 = [d8; d(p-1,:,q)]; % p>2, 1<q<p
    end
  end

	% d8 = d8_case x size = d8_case x dim
	% d8_case = [(p,q)] = [ (3,2)  (4,2)(4,3)  (5,2)(5,3)(5,4)  (6,2)...(6,5)

  %d2 = sort(d2(:));
  %d3 = sort(d3(:));
  %d6 = sort(d6(:));
  %d7 = sort(d7(:));
  %d8 = sort(d8(:));

  %printf('\n');
  %printf('Case 2 = %f%%\n', 100*(numel(d2)/numel(d)) );
  %printf('Case 3 = %f%%\n', 100*(numel(d3)/numel(d)) );
  %printf('Case 6 = %f%%\n', 100*(numel(d6)/numel(d)) );
  %printf('Case 7 = %f%%\n', 100*(numel(d7)/numel(d)) );
  %printf('Case 8 = %f%%\n', 100*(numel(d8)/numel(d)) );


end % function extractCases(dataY)
