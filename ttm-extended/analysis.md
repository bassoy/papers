#runtime analysis

## CPU
num-max threads = 64

## Par-Loop vs Par-Gemm

When does `par-loop` outperform `par-gemm` ?
Looking only at case 8 where `1 < q < p` and `p>2`
---
Lets do `nonsymmetric`:
* `par-gemm` outperforms `par-loop` with `2D` slices when
    * note that `par-loop-count`=2**(p-2) 
    * p=q+1:q+3 for q=2:3, 
    * p=q+1:q+2 for q=4, 
    * p=q+1 for q=5:6 
* `par-gemm` outperforms `par-loop` with `qD` slices when
    * note that `par-loop-count`=2**(p-q)
    * p=q+1:q+3 for q=2:5,
    * p=q+1:q+2 for q=6:8, 
    * p=q+1 for q=9
* `par-loop` with `2D` slices outperform `qD` ones 

It seems that `par-loop-count`~`num-cores` for `par-loop` to be faster than `par-gemm`
=> use `par-gemm` when `par-loop-count` is less than `num-par-count` 
=> always use `par-loop` with `2D` slices when `par-loop-count` larger than `num-par-count` and when slice dimensions are larger 256.

Is it related to other factors like matrix dimensions?
* If yes, smaller dimensions but same the same number of `par-loop-count` must have an influence on the runtime. 
    * can't see a pattern for `nonsymmetric` if the slice dimension gets larger for the same `q`

---    
Lets do `symmetric`:
* `par-loop` outperforms `par-gemm` with `2D` slices for almost all `q`,`p`,`dim` constellations except for `p=7`
    * weirdly the larger `par-gemm` outperforms `par-loop` for `symmetric` shapes and `q=7` where `dim=8` to `dim=16`
* `par-loop` outperforms `par-gemm` with `qD` slices for almost all `q`,`p`,`dim` constellations (also for `p=7`)
* `par-loop` with `qD` slices outperforms the one with `2D` slices.


=> compute `par-loop-count` with `par-loop` with `qD` slices
=> IF `par-loop-count` > `num-procs` THEN use `par-loop` with `qD` slices.
=> ELSE compute `par-loop-count` with `par-loop` with `2D` slices 
    => IF `par-loop-count` > `num-procs` THEN use `par-loop` with `2D` slices
    => ELSE use `par-gemm` with `qD` slices (`par-gemm` with `2D` slices does perform for non-symmetric and symmetric tensor shapes)











## NonSymmetric

c-mode (q) | order (p) | slice-dim | par-method | num-par-loops |
|----------|-----------|-----------|------------|---------------|
| 3        | 4         | 2D        | par-loop   | 4             |
| 3        | 4         | qD        | par-loop   | 2             |
| 3        | 4         | 2D        | par-gemm   |   1024x4096*k |
| 3        | 4         | qD        | par-gemm   | 2*1024x4096*k | <-
|----------|-----------|-----------|------------|---------------|
| 3        | 5         | 2D        | par-loop   | 8             |
| 3        | 5         | qD        | par-loop   | 4             |
| 3        | 5         | 2D        | par-gemm   |   1024x2048*k |
| 3        | 5         | qD        | par-gemm   | 2*1024x2048*k | <-
|----------|-----------|-----------|------------|---------------|
| 3        | 6         | 2D        | par-loop   | 16            |
| 3        | 6         | qD        | par-loop   | 8             |
| 3        | 6         | 2D        | par-gemm   |   1024x1024*k |
| 3        | 6         | qD        | par-gemm   | 2*1024x1024*k | <-
|----------|-----------|-----------|------------|---------------|
| 3        | 7         | 2D        | par-loop   | 32            |
| 3        | 7         | qD        | par-loop   | 16            |
| 3        | 7         | 2D        | par-gemm   |   1024x512*k  |
| 3        | 7         | qD        | par-gemm   | 2*1024x512*k  | <-
|----------|-----------|-----------|------------|---------------|
| 3        | 8         | 2D        | par-loop   | 64            |
| 3        | 8         | qD        | par-loop   | 32            |
| 3        | 8         | 2D        | par-gemm   |   1024x256*k  |
| 3        | 8         | qD        | par-gemm   | 2*1024x26*k   |
|----------|-----------|-----------|------------|--------------------------|
|----------|-----------|-----------|------------|--------------------------|
| 4        | 5         | 2D        | par-loop   | 8                        |
| 4        | 5         | qD        | par-loop   | 2                        |
| 4        | 5         | 2D        | par-gemm   |   1024x(2048:2048:16384) |
| 4        | 5         | qD        | par-gemm   | 4*1024x(2048:2048:16384) |
|----------|-----------|-----------|------------|--------------------------|
| 4        | 6         | 2D        | par-loop   | 16                       |
| 4        | 6         | qD        | par-loop   | 4                        |
| 4        | 6         | 2D        | par-gemm   |   1024x(1024:1024:8192)  |
| 4        | 6         | qD        | par-gemm   | 4*1024x(1024:1024:8192)  |
|----------|-----------|-----------|------------|--------------------------|
| 3        | 7         | 2D        | par-loop   | 32                       |
| 3        | 7         | qD        | par-loop   | 8                        |
| 3        | 7         | 2D        | par-gemm   |   1024x(512:512:4096)    |
| 3        | 7         | qD        | par-gemm   | 4*1024x(512:512:4096)    |
|----------|-----------|-----------|------------|--------------------------|
| 4        | 8         | 2D        | par-loop   | 64                       |
| 4        | 8         | qD        | par-loop   | 16                       |
| 4        | 8         | 2D        | par-gemm   |   1024x(256:256:2048)    |
| 4        | 8         | qD        | par-gemm   | 4*1024x(256:256:2048)    |

### Generalization:

case 8 (`q<p`)
`<par-loop,seq-gemm,2d>`: loop-count = `2**(p-2)`, mm-size=1024x(512:512:4096)
`<par-loop,seq-gemm,qd>`: loop-count = `2**(p-q)`, mm-size=((p-q)*1024)x(512:512:4096)

`<seq-loop,par-gemm,2d>`: loop-count = `2**(p-2)`, 
`<seq-loop,par-gemm,qd>`: loop-count = `2**(p-q)`



## Symmetric

### Threadedgemm vs OmpForLoop for Sliced Tensors
* Note that everything `q>p` is case 7 and for all methods the same. 
* [Unclear] Seems that `speed_slice` goes up as `dim` goes up.
    * e.g. for `p=4` -> `dim=64...128` and `loopcount=dim^2`
    * e.g. for `p=5` -> `dim=32...64`  and `loopcount=dim^3`
    * e.g. for `p=6` -> `dim=16...32`  and `loopcount=dim^4`
    * I expect that a small `dim` is more beneficial for `ompfor` 
      So the largest speedups must be at first elements of a particular speedup row. 
    * [P.Explanation] Maybe the large `loopcount` for `ompfor` has a greater impact than the small `dim`
    * [P.Explanation] The function call overhead needs also have a influence
* [Unclear] Related to the previous statement, with increasing `p`, `dim` decreases and the `loopcount` increases.
    * I expect that `speed_slice` goes up with increasing `p` and decreasing `dim` 
      because the `threadedgemm` will execute a parallel `gemm` on small dimensions while
      `ompforloop` will execute sequential `gemm` in parallel. 
      
### Threadedgemm vs OmpForLoop for Subtensors
* [Unclear] Similar behavior as before regarding `speed_subtensor`:
    * As `dim` increases `speed_subtensor` increases while loopcount
