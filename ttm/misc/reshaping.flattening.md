#Reshaping:

```matlab

pi = 1,2,3
n  = 4,5,6

rho = 3,2,1

tau = [ tau(1), tau(2), tau(3) ] = [ pi(rho(1)), pi(rho(2)), pi(rho(3)) ] = [ pi(3), pi(2), pi(1) ] = [ 3, 2, 1 ]
m   = [ m(1), m(2), m(3) ]       = [ n(rho(1)), n(rho(2)), n(rho(3)) ]    = [ n(3), n(2), n(1) ]    = [6,5,4]


pi = 3,2,1
n  = 4,5,6

rho = 3,2,1

tau = [ tau(1), tau(2), tau(3) ] = [ pi(rho(1)), pi(rho(2)), pi(rho(3)) ] = [ pi(3), pi(2), pi(1) ] = [ 1, 2, 3 ]
m   = [ m(1), m(2), m(3) ]       = [ n(rho(1)), n(rho(2)), n(rho(3)) ]    = [ n(3), n(2), n(1) ]    = [6, 5, 4]


```

## First reshape then flatten ? 

```
pi = [pi(1), ..., pi(p) ]

        1, 2,  3, ..., q',   q'+1, ..., p
rho = [ 1, q', 2, ..., q'-1, q'+1, ..., p ]

tau = [ tau(1),...tau(p) ] =  [ pi(rho(1)), pi(rho(2)), pi(rho(3)), ...  pi(rho(q')), pi(rho(q'+1)), ... pi(rho(p)) ] = [ pi(1), pi(q'), pi(2), ... , pi(q'-1), pi(q'+1), ... , pi(p) ]

    => tau(1) = pi(1) , tau(2) = pi(q'), tau(3) = pi(2), ..., tau(q'-1) = pi(q'), ...
   

m = [n(rho(1), ... , n(rho(p))] = [ n(1), n(q'), n(2), ... , n(q'-1), n(q'+1), ... , n(p) ] 

```

## flatten twice (slice-matrix)


```
pi = [pi(1), ..., pi(p) ] // 1 , 2 , 3 , ... , 7

q' > 2

1. varphi_{2,q'-1}  // 2, 3 with q' = 4 or 2,3,4 with q' = 5

 // note that q does not have to be the q-th element in pi! It is a the q'-th position
=> pi' = [pi(1), pi(2), q-s, pi(q'+1)-s, ..., pi(p)-s] // 1,2,4-1,5-1,...,7-1  or 1,2,5-2,...7-2 

=> n'(pi(2)) = n(pi(2)) *...* n(pi(q'-1)) // n(2)*n(3) or n(2)*...*n(4)

=> n' = [n(1), ..., n(p-q'+3) ] // n(1),n'(2),n(4),n(5),n(6),n(7) or n(1),n'(2),n(5),n(6),n(7)

=> p'= p-q'+3


2. varphi_{4,p'}

=> pi'' = [pi'(1), pi'(2), q-s, pi'(4)]

=> n''(pi''(4)) = n'(pi'(4)) *...* n'(pi'(p'))
=> n''(pi''(r)) = n'(pi'(r)) r = 1,..,3




```

=> no reshape necessary for slice-matrix multiplications

```
for i4 = 1 to n''(pi''(4)) 
	for i2 = 1 to n''(pi''(2)) 
		j = j + i2*w(pi''(2)) + i4*w(pi''(4))
		GEMM with A + j and C + j 
```

## Subtensor-Matrix: Flatten twice


```
pi = [pi(1), ..., pi(p) ]



1. varphi_{q'+1,p} 

=> pi = [pi(1), ... , pi(q'-1),  q, pi(q'+1), ..., pi(p)]

=> pi' = [pi(1), ... , pi(q'-1), q, pi'(q'+1)]

=> n(pi(q'+1)) =  n(pi(q'+1)) *...* n(pi(p))


=> p'= q'+1

=> n = [n(1), ..., n(q'), n(q'+1) ]



2. varphi_{1,q'-1} 

=> pi' = [pi(1), ... , pi(q'-1), q, pi'(q'+1)]

=> pi'' = [pi'(1), q, pi'(q'+1)]

=> n''(pi'(1)) =  n'(pi'(1)) *...* n'(pi'(q'-1))


=> p'' = q'+1

=> n = [n(1), n(2), n(3) ]

```

=> no reshape necessary for subtensor-matrix multiplications

```
for i(pi'(4)) = 1 to n(pi'(4)) 
	j = j + w(pi'(4))
	GEMM with A + j and C + j 
```



## tensor slices


```
pi' = [ pi(1), pi(q') ] = [ pi(1), q ] 

if pi(1) < q => column-major format
if pi(1) > q => row-major format

no cannot say so. it does not have any valid format


z.B.

q = 3 und pi(1) = 2 ==> pi' = [2, 3]    so that    i2..n2 with w2=1 and iq..nq with wq!=1
A'=A{2,3} with n2,n3 and C'=C{2,3} with n2,m and B with m,n3     so that     C'(m,n2) = B(m,n3) * A(n3,n2)
 
q = 3 und pi(1) = 4 ==> pi' = [4, 3]    so that    i4..n4 with w4=1 and iq..nq with wq!=1
A'=A{4,3} with n4,n3 and C'=C{4,3} with n4,m and B with m,n3     so that     C'(m,n4) = B(m,n3) * A(n3,n4)


```



