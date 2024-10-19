# Extension

## Minor



## Major

* Section Introduction:
    * [todo] adds additional references
    * [todo] adds additional major contribution ??
* Section Background:
    * [todo] instead of subtensor, the notion of qd-slices is used.
    * [todo] add cblas description with paramater explanation. 
* Section Algorithm:
    * description considers + table includes matrix B with column-major format
    * [todo] decide if you want the table to be included
        * [done] extra chapter reveals
* Section Experimental Setup:
    * [todo] adds better description to the tensor shapes 
* Section Results:
    * all results and plots are new, while validating the former findings
        * instead of one Intel Cascade CPU, more recent AMD and Intel server CPUs are used to validate the algorithms
        * hence the number of figure is doubled 
    * all algorithms including the competing frameworks are executed on AMD and Intel CPUs
    * next to MKL, the AOCL library is used for AMD
        * [todo] the performance difference between MKL and AOCL for AMD is reported.
    * [todo] fine granular distinguishment betweeen different algorithm versions!! 
* TLIB.TTM Implementation:
    * also supports matrix B with column-major format
    * also supports aocl lifbrary, next to openblas and mkl
    
    

