#runtime analysis

## th-gemm vs. ompfor (genoa)

Example dim3 (meaning q=3) on symmetrically-shaped tensors:

Given the symmetric shapes:
```
[(4096, 4096):(512, 512):(8192, 8192)]
[(256, 256, 256):(32, 32, 32):(512, 512, 512)]
[(64, 64, 64, 64):(8, 8, 8, 8):(128, 128, 128, 128)]
[(32, 32, 32, 32, 32):(4, 4, 4, 4, 4):(64, 64, 64, 64, 64)]
[(16, 16, 16, 16, 16, 16):(2, 2, 2, 2, 2, 2):(32, 32, 32, 32, 32, 32)]
[(8, 8, 8, 8, 8, 8, 8):(1, 1, 1, 1, 1, 1, 1):(16, 16, 16, 16, 16, 16, 16)]
```
The speedup is given by:
```
speed_slice_dim3 = tlib_threadedgemm_slice_dim3_time./tlib_ompforloop_slice_all_dim3_time;
speed_subtensor_dim3 = tlib_threadedgemm_subtensor_dim3_time./tlib_ompforloop_subtensor_outer_dim3_time;
```
where
```
speed_subtensor_dim3 = 

   0.8549   1.0331   1.6087   1.0070   0.8486   0.7002   0.6962   1.2248   0.9387
   0.9766   4.1206   3.2378   2.4301   1.9287   1.6075   1.5654   1.4831   1.0152
   0.3963   0.9209   0.8618   1.2283   1.3001   2.2951   1.3922   1.1634   1.6372
   2.3774   2.7595   4.3091   4.0069   4.4792   2.6691   2.5038   2.5684   2.4063
   3.1996   3.2657   4.6012   3.9635   5.8034   4.8554   4.5643   4.6252   5.0645
   3.0654   3.4582   3.7965   4.0826   4.2985   4.4037   4.9202   4.8029   5.4767
```
and
```
speed_slice_dim3 =

   0.9018   0.9916   0.5464   0.7551   0.5970   0.9090   1.1438   0.8910   0.8395
   0.3762   0.9812   1.0127   0.9778   0.9985   0.9912   1.0149   0.9140   0.9255
   3.1354   4.0306   4.9537   4.6552   5.6326   6.4763   7.2112   6.6795   7.9106
   3.6775   4.6689   5.6700   5.3065   5.6125   5.7270   6.0641   7.6915   5.3692
   0.7000   0.8907   0.9424   2.4580   2.4313   2.8717   3.0226   3.0687   2.8755
   0.4470   0.5381   0.5873   0.6156   0.6398   0.6653   0.6914   0.7252   0.7441
```

### Threadedgemm vs OmpForLoop for Sliced Tensors
* Note that everything `q>p` is case 7 and for all methods the same. 
* [Unclear] Seems that `speed_slice` goes up as `dim` goes up.
    * e.g. for `p=4` -> `dim=64...128` and `loopcount=dim^2`
    * e.g. for `p=5` -> `dim=32...64`  and `loopcount=dim^3`
    * e.g. for `p=6` -> `dim=16...32`  and `loopcount=dim^4`
    * I expect that a small `dim` is more beneficial for `ompfor` 
      So the largest speedups must be at first elements of a particular speedup row. 
    * [P.Explanation] Maybe the large `loopcount` for `ompfor` has a greater impact than the small `dim`
* [Unclear] Related to the previous statement, with increasing `p`, `dim` decreases and the `loopcount` increases.
    * I expect that `speed_slice` goes up with increasing `p` and decreasing `dim` 
      because the `threadedgemm` will execute a parallel `gemm` on small dimensions while
      `ompforloop` will execute sequential `gemm` in parallel. 
      
### Threadedgemm vs OmpForLoop for Subtensors
* [Unclear] Similar behavior as before regarding `speed_subtensor`:
    * As `dim` increases `speed_subtensor` increases while loopcount
