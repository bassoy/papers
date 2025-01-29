-----------------------------
--------- [review1] ---------
-----------------------------

Major concerns:
[x] This paper is not self-contained, e.g., lines 228 and 632. Please write important things in this paper and do not refer to other papers to omit the explanation. Otherwise, readers will have to open the referred papers to read this paper.
    * line 228: the algorithm description has been updated and is now self-contained. it has been made clear that the following algorithm design is similar to one that has been previously described. 
    *  line 632: the tensor setup description has been updated and is now self-contained. TODO: should I add the dimension tables?
    *  line 204: layout function description improved.

[o] The author mentions that the performance of matrix multiplication is not memory-bound in line 156, but it is not always true, for example, a multiplication of two tall-skinny matrices and bached small matrix multiplications. For better performance analysis, it would be better to use a roofline model in the evaluation section.
    * This is correct. A matrix-matrix multiplication can be memory-bound. Line 156 has been updated accordingly.

[x] What is the essential difference between Algorithm 2 and TTGT? Is it true that both are the same if we put all \underbar{A'}_{i,j} matrices in a continuous memory space and interpret it as a large matrix?
    * TTGT flattens tensors into matrices with respect to the contraction mode and therefore needs to allocate additional memory and copy tensor elements. 
    * In contrast, with our LoG-approach no copy operation is performed. Hence, here "flatten" is a non-copy operation as defined in subsection 3.5 and explained in line 463. 
    * However, I think the reviewer is understandably confused and misguided. Hence, "flatten" is renamed to "reshape" to avoid confusion. 

[x] There are some undefined words, such as TTV and TTM.
    * This has been corrected. "TTM" is now first mentioned in the introduction section and additionally defined in section.
    
[x] It would be better to write an explanation of the experimental evaluation in a summary way. It is very hard to understand the evaluation results from the explanations. Also, there are many detailed numbers, especially on page 11, which make it difficult to understand the summary of the evaluation. What about changing the vertical axis of Figure 2 to the performance efficiency?
    * Removed verbose performance results and added a new table (Table 2) summarizing all min/median/max performance values 
    * Added summary subsection 6.6 at the end of the results section to summarize the complete results section. 

[x] Are there any tensor shapes where the proposed method has lower performance than the existing methods? The cumulative axis does not help to show this.
    * line 877 mentions TBLIS
    * starting at line 895, the following paragraphs describe cases where TLIB and the proposed algorithm is slower.

# Minor concerns:
[x] It would be better to make a table or something to explain , etc, and also not to use the same label for subtensors and tensor slices, for example, in Figure 2.
    * different labels are now used for functions with subtensors and tensor slices
    
[x] Line 226: tensor-times-matrix -> tensor-matrix
    * corrected.
    
[x] What is the "see [17, 14]" in line 204 for?
    * This has been corrected.
    
[x] Please cite more papers if the author write "many", for example, in lines 2 and 32. 
    * This has been corrected.


-----------------------------
--------- [review2] ---------
-----------------------------

[x] The author needs to motivate why designing a TTM operation for an arbitrary tensor layout is important. Prior works have generally focused on choosing some fixed layout (usually row or column oriented), and then argued that for tensors that don’t satisfy this assumption, the tensor dimension order can always be permuted to match the assumed ordering. Why not just fix a layout but develop TTM operations for an arbitrary mode in that ordering?
    * the justification has been integrated into the introduction section.  [todo] need to further explain here. 

[] The author needs to describe how this work contrasts with the well-known TuckerMPI approach, described in “TuckerMPI: A Parallel C++/MPI Software Package for Large-scale Data Compression via the Tucker Tensor Decomposition,” [...] There is also a thread-parallel implementation that is relevant, described in De et al, “Hybrid Parallel Tucker Decomposition of Streaming Data”, in PASC’23, https://doi.org/10.1145/3659914.36599.
    * 

[] One contribution claimed by the author is ability to do an in-place TTM, inwhich case the author should also contrast this work with “FIST-HOSVD: fused in-place sequentially truncated higher order singular value decomposition”. I think the author should then include memory usage in the numerical comparisons instead of focusing purely on compute time/throughput.
    * 
    
[x] What is the point of including Cases 1-5 on page 4 and Table 1, since those are for order 1 or 2 tensors (i.e., vectors or matrices) and fall into standard linear algebra use-cases?
    * This part of the table is necessary when the tensor is of order one and two. We do not want to restrict the TTM implementation and the library to tensors with tensor order larger than two as TTM is also defined when the tensor order is one or two. These cases might be used less in practice.

[x] I can’t quite follow Algorithm 1. What is \hat{q} in this algorithm? It is not described in the caption, nor the explanatory text on page 3.
    * The parameters of algorithm 1 are now described including \hat{q} where q=\hat{q} if the first-order storage format is used.

[x] I don’t think the author needs to describe how to switch from row to column-major order for the matrix in TTM (sections 4.2.2 and 4.2.3), since this is well-known.
    * section 4.2.2. describes the adaption of table 1 for a column-major matrix
    * section 4.2.3. describes the adaption of table 1 if the multiplication format differs from the one of the input matrix
    * In both cases, the adaptions can be cumbersome (multiple arguments must be adjusted) which is why I would like to leave the brief description.

[] I think the paper would be well-served by including numerical comparisons on some real data set, to make the contributions of the paper more concrete. My suggestion would be the SP data set which was used in some of the above papers, and is available publicly at https://sdrbench.github.io/ (under the title of S3D).

-----------------------------
--------- [review3] ---------
-----------------------------

[] My only concern is that the author should clearly highlight the differences between this submission and the previously accepted conference paper [1], particularly in terms of contributions.


