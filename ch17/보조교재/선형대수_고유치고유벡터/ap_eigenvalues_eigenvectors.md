Chapter 9. Eigenvalues and Eigenvectors
========================================================

* 발제 : 김무성
* 참고문헌 :  Hands-On Matrix Algebra Using R: Active and Motivated Learning with Applications / Hrishikesh D Vinod 

# 9.1 Characteristic Equation

### R program snippet 9.1.1

```r
A = matrix(1:4,2); A #view A
```

```
##      [,1] [,2]
## [1,]    1    3
## [2,]    2    4
```

```r
ea = eigen(A) # object ea contains eigenvalues-vectors of A
ea
```

```
## $values
## [1]  5.3723 -0.3723
## 
## $vectors
##         [,1]    [,2]
## [1,] -0.5658 -0.9094
## [2,] -0.8246  0.4160
```

```r
lam = ea$val[1]; lam #view lambda
```

```
## [1] 5.372
```

```r
x = ea$vec[,1]; x # view x
```

```
## [1] -0.5658 -0.8246
```

```r
lam*diag(2)
```

```
##       [,1]  [,2]
## [1,] 5.372 0.000
## [2,] 0.000 5.372
```

```r
det(A-lam*diag(2)) # should be zero
```

```
## [1] 0
```

```r
sqrt(sum(x^2)) # Eculidean length of x is 1
```

```
## [1] 1
```

```r
lam^2-5*lam # solving quadratic OK if this is 2
```

```
## [1] 2
```

### R program snippet 9.1.1 설명
![코드9.1.1 설명](figure/st911.png)

# 9.2 Eigenvalues and Eigenvectors of Correlation Matrix

### R program snippet 9.1.1

```r
set.seed(93); x = matrix(sample(1:90), 10, 3)
x
```

```
##       [,1] [,2] [,3]
##  [1,]   34   10   46
##  [2,]   29   82   45
##  [3,]   23   78    7
##  [4,]   90   72   13
##  [5,]   66   64   76
##  [6,]    4   26   42
##  [7,]   70   61   69
##  [8,]    5   89   30
##  [9,]   86   59   50
## [10,]   25    6   20
```

```r
A = cor(x); A # corrlation matrix for columns of x
```

```
##        [,1]     [,2]     [,3]
## [1,] 1.0000  0.18780  0.30091
## [2,] 0.1878  1.00000 -0.03818
## [3,] 0.3009 -0.03818  1.00000
```

```r
x[2,1] = NA # insert missing data in column 1
x
```

```
##       [,1] [,2] [,3]
##  [1,]   34   10   46
##  [2,]   NA   82   45
##  [3,]   23   78    7
##  [4,]   90   72   13
##  [5,]   66   64   76
##  [6,]    4   26   42
##  [7,]   70   61   69
##  [8,]    5   89   30
##  [9,]   86   59   50
## [10,]   25    6   20
```

```r
x[1,3] = NA # insert missing data in cloumn 3
x
```

```
##       [,1] [,2] [,3]
##  [1,]   34   10   NA
##  [2,]   NA   82   45
##  [3,]   23   78    7
##  [4,]   90   72   13
##  [5,]   66   64   76
##  [6,]    4   26   42
##  [7,]   70   61   69
##  [8,]    5   89   30
##  [9,]   86   59   50
## [10,]   25    6   20
```

```r
library(Hmisc) # bring Hmisc package into R memory
```

```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
rcorr(x) # produces 3 matrices
```

```
##      [,1] [,2] [,3]
## [1,] 1.00 0.25 0.34
## [2,] 0.25 1.00 0.01
## [3,] 0.34 0.01 1.00
## 
## n
##      [,1] [,2] [,3]
## [1,]   10    9    8
## [2,]    9   10    9
## [3,]    8    9   10
## 
## P
##      [,1]   [,2]   [,3]  
## [1,]        0.5101 0.4167
## [2,] 0.5101        0.9708
## [3,] 0.4167 0.9708
```



