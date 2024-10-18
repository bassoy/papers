%
% [tlib_gflops,tlib_times,sizes,gflops] = read_profile_data("icelake","symmetric","order1","rm")
function [tlib_gflops,tlib_times,sizes,gflops] = read_profile_data(processor, shape, aformat, bformat)

  processor
  shape
  aformat
  bformat

  if (strcmp(processor,"icelake"))
    blas="mkl";
    cores=48;
  else
    blas="aocl";
    cores=64;
  end

  if strcmp(shape,"symmetric")
    modes=1:7;
    order=2:7;
  else
    modes=1:10;
    order=2:10;
  end


  folderin=['/home/bascem/Desktop/auswertung/files_profile/ttm/',processor,'/tlib/tensor/',blas,'/',shape,'/',aformat,'/',bformat,'/','double'];



  % order x size x cmode

  tlib_threadedgemm_slice_gflops = [];
  tlib_threadedgemm_subtensor_gflops = [];
  tlib_ompforloop_slice_all_gflops = [];
  tlib_ompforloop_subtensor_outer_gflops = [];
  tlib_optimized_gflops = [];


  for k = modes
    script = cstrcat(folderin ,"/", "data_dim", num2str(k),".m");
    run(script);
    gflops                               = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_ops" ));
    sizes                                = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_size")); % order x size
    tlib_threadedgemm_slice_time         = eval(cstrcat("tlib_threadedgemm_slice_dim",         num2str(k),"_time"));
    tlib_threadedgemm_subtensor_time     = eval(cstrcat("tlib_threadedgemm_subtensor_dim",     num2str(k),"_time"));
    tlib_ompforloop_slice_all_time       = eval(cstrcat("tlib_ompforloop_slice_all_dim",       num2str(k),"_time"));
    tlib_ompforloop_subtensor_outer_time = eval(cstrcat("tlib_ompforloop_subtensor_outer_dim", num2str(k),"_time"));
    tlib_optimized_time                  = eval(cstrcat("tlib_optimized_dim",                  num2str(k),"_time"));
    tlib_bgemm_time                      = ones(size(tlib_optimized_time));
    if (strcmp(processor,"icelake"))
      tlib_bgemm_time                    = eval(cstrcat("tlib_batchedgemm_subtensor_outer_dim",num2str(k),"_time"));
    end
    gflops *= 1e-9;


    tlib_threadedgemm_slice_times         (:,:,k) = tlib_threadedgemm_slice_time         ;
    tlib_threadedgemm_subtensor_times     (:,:,k) = tlib_threadedgemm_subtensor_time     ;
    tlib_ompforloop_slice_all_times       (:,:,k) = tlib_ompforloop_slice_all_time       ;
    tlib_ompforloop_subtensor_outer_times (:,:,k) = tlib_ompforloop_subtensor_outer_time ;
    tlib_optimized_times                  (:,:,k) = tlib_optimized_time                  ;
    tlib_bgemm_times                      (:,:,k) = tlib_optimized_time                  ;

    tlib_threadedgemm_slice_gflops        (:,:,k) = gflops ./ tlib_threadedgemm_slice_time         ;
    tlib_threadedgemm_subtensor_gflops    (:,:,k) = gflops ./ tlib_threadedgemm_subtensor_time     ;
    tlib_ompforloop_slice_all_gflops      (:,:,k) = gflops ./ tlib_ompforloop_slice_all_time       ;
    tlib_ompforloop_subtensor_outer_gflops(:,:,k) = gflops ./ tlib_ompforloop_subtensor_outer_time ;
    tlib_optimized_gflops                 (:,:,k) = gflops ./ tlib_optimized_time                  ;
    tlib_bgemm_gflops                     (:,:,k) = gflops ./ tlib_bgemm_time                      ;
  end

  dims = size(tlib_threadedgemm_slice_gflops);

  tlib_gflops = zeros([dims 6]);
  tlib_gflops(:,:,:,1) = tlib_threadedgemm_slice_gflops;
  tlib_gflops(:,:,:,2) = tlib_threadedgemm_subtensor_gflops;
  tlib_gflops(:,:,:,3) = tlib_ompforloop_slice_all_gflops;
  tlib_gflops(:,:,:,4) = tlib_ompforloop_subtensor_outer_gflops;
  tlib_gflops(:,:,:,5) = tlib_optimized_gflops;
  tlib_gflops(:,:,:,6) = tlib_bgemm_gflops;

  tlib_times = zeros([dims 6]);
  tlib_times(:,:,:,1) = tlib_threadedgemm_slice_times;
  tlib_times(:,:,:,2) = tlib_threadedgemm_subtensor_times;
  tlib_times(:,:,:,3) = tlib_ompforloop_slice_all_times;
  tlib_times(:,:,:,4) = tlib_ompforloop_subtensor_outer_times;
  tlib_times(:,:,:,5) = tlib_optimized_times;
  tlib_times(:,:,:,5) = tlib_bgemm_times;

end
