IRT(문항반응이론)
========================================================

발표자 : 이세리


```r
#install.packages("psych")
#install.packages("ltm")
```


```r
library(psych)
library(ltm)
```

```
## Loading required package: MASS
## Loading required package: msm
## Loading required package: polycor
## Loading required package: mvtnorm
## Loading required package: sfsmisc
## 
## Attaching package: 'polycor'
## 
## The following object is masked from 'package:psych':
## 
##     polyserial
## 
## 
## Attaching package: 'ltm'
## 
## The following object is masked from 'package:psych':
## 
##     factor.scores
```


```r
data(bock)

class(lsat6)
```

```
## [1] "matrix"
```

```r
str(lsat6)
```

```
##  int [1:1000, 1:5] 0 0 0 0 0 0 0 0 0 0 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:5] "Q1" "Q2" "Q3" "Q4" ...
```

```r
head(lsat6)
```

```
##      Q1 Q2 Q3 Q4 Q5
## [1,]  0  0  0  0  0
## [2,]  0  0  0  0  0
## [3,]  0  0  0  0  0
## [4,]  0  0  0  0  1
## [5,]  0  0  0  0  1
## [6,]  0  0  0  0  1
```

```r
summary(lsat6)
```

```
##        Q1              Q2              Q3              Q4       
##  Min.   :0.000   Min.   :0.000   Min.   :0.000   Min.   :0.000  
##  1st Qu.:1.000   1st Qu.:0.000   1st Qu.:0.000   1st Qu.:1.000  
##  Median :1.000   Median :1.000   Median :1.000   Median :1.000  
##  Mean   :0.924   Mean   :0.709   Mean   :0.553   Mean   :0.763  
##  3rd Qu.:1.000   3rd Qu.:1.000   3rd Qu.:1.000   3rd Qu.:1.000  
##  Max.   :1.000   Max.   :1.000   Max.   :1.000   Max.   :1.000  
##        Q5      
##  Min.   :0.00  
##  1st Qu.:1.00  
##  Median :1.00  
##  Mean   :0.87  
##  3rd Qu.:1.00  
##  Max.   :1.00
```

```r
lsat6[0:10,]
```

```
##       Q1 Q2 Q3 Q4 Q5
##  [1,]  0  0  0  0  0
##  [2,]  0  0  0  0  0
##  [3,]  0  0  0  0  0
##  [4,]  0  0  0  0  1
##  [5,]  0  0  0  0  1
##  [6,]  0  0  0  0  1
##  [7,]  0  0  0  0  1
##  [8,]  0  0  0  0  1
##  [9,]  0  0  0  0  1
## [10,]  0  0  0  1  0
```

```r
ord <- order(colMeans(lsat6), decreasing=TRUE)
ord
```

```
## [1] 1 5 4 2 3
```

```r
lsat6.sorted <- lsat6[, ord]
lsat6.sorted[0:10,]
```

```
##       Q1 Q5 Q4 Q2 Q3
##  [1,]  0  0  0  0  0
##  [2,]  0  0  0  0  0
##  [3,]  0  0  0  0  0
##  [4,]  0  1  0  0  0
##  [5,]  0  1  0  0  0
##  [6,]  0  1  0  0  0
##  [7,]  0  1  0  0  0
##  [8,]  0  1  0  0  0
##  [9,]  0  1  0  0  0
## [10,]  0  0  1  0  0
```

```r
describe(lsat6.sorted)
```

```
##    vars    n mean   sd median trimmed mad min max range  skew kurtosis
## Q1    1 1000 0.92 0.27      1    1.00   0   0   1     1 -3.20     8.22
## Q5    2 1000 0.87 0.34      1    0.96   0   0   1     1 -2.20     2.83
## Q4    3 1000 0.76 0.43      1    0.83   0   0   1     1 -1.24    -0.48
## Q2    4 1000 0.71 0.45      1    0.76   0   0   1     1 -0.92    -1.16
## Q3    5 1000 0.55 0.50      1    0.57   0   0   1     1 -0.21    -1.96
##      se
## Q1 0.01
## Q5 0.01
## Q4 0.01
## Q2 0.01
## Q3 0.02
```

```r
Tau <- round(-qnorm(colMeans(lsat6.sorted)),2)   #tau : estimates of threshold
#round : rounds the values in its first argument to the specified number of decimal places
#qnorm : quantile function with mean=0, sd=1
Tau
```

```
##    Q1    Q5    Q4    Q2    Q3 
## -1.43 -1.13 -0.72 -0.55 -0.13
```

```r
rasch(lsat6.sorted, constraint=cbind(ncol(lsat6.sorted)+1, 1.702))
```

```
## 
## Call:
## rasch(data = lsat6.sorted, constraint = cbind(ncol(lsat6.sorted) + 
##     1, 1.702))
## 
## Coefficients:
## Dffclt.Q1  Dffclt.Q5  Dffclt.Q4  Dffclt.Q2  Dffclt.Q3     Dscrmn  
##    -1.927     -1.507     -0.960     -0.742     -0.195      1.702  
## 
## Log.Lik: -2541
```

```r
# constraint :  The first column represents the item (p+1 - 문항변별력 discrimination parameter)
#       the second column the value at which the corresponding parameter should be fixed
```

