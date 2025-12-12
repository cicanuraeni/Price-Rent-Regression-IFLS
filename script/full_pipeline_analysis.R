###############################################
#                MODEL AWAL
###############################################
library(readxl)
data <- read_excel("C:/Users/Asus/Downloads/awal.xlsx")
y  <- as.matrix(data[,1])
X0 <- as.matrix(data[,-1])
n  <- nrow(y)
u  <- matrix(1, n, 1)
X  <- cbind(u, X0)

# Koefisien regresi
b <- solve(t(X)%*%X)%*%t(X)%*%y

# Matriks Hat
H <- X%*%solve(t(X)%*%X)%*%t(X)
I <- diag(1, n, n)
J <- matrix(1, n, n)

# SSE, SSR, SST, R2
SSE <- t(y)%*%(I-H)%*%y
SSR <- t(y)%*%(H-(J/n))%*%y
SST <- SSE + SSR
p   <- ncol(X)
R2  <- SSR/SST

###############################################
#                OUTLIER
###############################################

e  <- (I-H)%*%y
s2 <- SSE/(n-p)
s  <- sqrt(s2)

# Studentized deleted residual
d    <- e / diag(I-H)
MSEi <- (matrix(SSE, n, 1) - e*e/diag(I-H)) / (n-p-1)
vd   <- MSEi / diag(I-H)
t    <- d / sqrt(vd)

alpha <- 0.05
t_cri <- qt(1 - alpha/n/2, n-p-1)
which(t >= t_cri)

###############################################
#          MULTIKOLINEARITAS (VIF)
###############################################

R   <- cor(X0)
VIF <- diag(solve(R))
VIF

###############################################
#      HOMOSKEDASTISITAS (Breusch–Pagan)
###############################################

y2 <- e*e
X  <- X
k  <- ncol(X)-1

H   <- X%*%solve(t(X)%*%X)%*%t(X)
SSE <- t(y2)%*%(I-H)%*%y2
SSR <- t(y2)%*%(H-(J/n))%*%y2
SST <- SSE + SSR

R2   <- SSR/SST
chi2 <- n * R2
chi_c <- qchisq(1-alpha, k)

###############################################
#            LINEARITAS (RESET)
###############################################

SSE0 <- t(y)%*%(I-H)%*%y
yh   <- H%*%y
yh2  <- yh*yh
yh3  <- yh2*yh

X1 <- cbind(X, yh2, yh3)
q  <- ncol(X1) - ncol(X) + 1

H1  <- X1%*%solve(t(X1)%*%X1, tol=1e-39)%*%t(X1)
SSE1 <- t(y)%*%(I-H1)%*%y

f1     <- (SSE0-SSE1)/(q-1) / (SSE1/(n-k-q))
fcrit  <- qf(1-alpha, q-1, n-k-q)
p_val1 <- 1 - pf(f1, q-1, n-k-q)

###############################################
#               LOG–LOG MODEL
###############################################

data <- read_excel("C:/Users/Asus/Downloads/akhir.xlsx")
y  <- as.matrix(data[,1])
X0 <- as.matrix(data[,-1])
n  <- nrow(y)
u  <- matrix(1, n, 1)
X  <- cbind(u, X0)

H <- X%*%solve(t(X)%*%X)%*%t(X)
I <- diag(1, n, n)
e <- (I-H)%*%y

SSE0 <- t(y)%*%(I-H)%*%y
p <- ncol(X)
k <- p-1

yh  <- H%*%y
yh2 <- yh*yh
yh3 <- yh2*yh

X1 <- cbind(X, yh2, yh3)
q  <- ncol(X1) - ncol(X) + 1

H1  <- X1%*%solve(t(X1)%*%X1, tol=1e-39)%*%t(X1)
SSE1 <- t(y)%*%(I-H1)%*%y

f1     <- (SSE0-SSE1)/(q-1)/(SSE1/(n-k-q))
fcrit  <- qf(1-alpha, q-1, n-k-q)
p_val1 <- 1 - pf(f1, q-1, n-k-q)

###############################################
#            STEPWISE BACKWARD
###############################################

# Cycle 1
X  <- cbind(u, X0[,1:20])
p  <- ncol(X)

bh  <- solve(t(X)%*%X)%*%t(X)%*%y
H   <- X%*%solve(t(X)%*%X)%*%t(X)
e   <- (I-H)%*%y
MSE <- (t(e)%*%e)/(n-p)
SE <- sqrt(diag(solve(t(X)%*%X) * as.numeric(MSE)))
t   <- bh/SE
p_v <- 2*(1 - pt(abs(t), n-p))

# Cycle 2
X <- cbind(u, X0[,c(2,3,4,5,7,9,13,14,15,17,18,20)])
p <- ncol(X)

bh  <- solve(t(X)%*%X)%*%t(X)%*%y
H   <- X%*%solve(t(X)%*%X)%*%t(X)
e   <- (I-H)%*%y
MSE <- (t(e)%*%e)/(n-p)
SE  <-  sqrt(diag(solve(t(X)%*%X) * as.numeric(MSE)))
t   <- bh/SE
p_v <- 2*(1 - pt(abs(t), n-p))
est <- cbind(bh, t, p_v)
R2  <- 1 - MSE/var(y)

###############################################
# HETEROSKEDASTISITAS (MODEL TERPILIH)
###############################################
y  <- e2
X  <- X
p  <- ncol(X)
k  <- p-1

n  <- nrow(X)                 # <- penting
I  <- diag(1, n, n)
J  <- matrix(1, n, n)         # <- harus sama ukuran H

H  <- X %*% solve(t(X)%*%X) %*% t(X)

SSE <- t(y) %*% (I-H) %*% y
SSR <- t(y) %*% (H - (J/n)) %*% y
SST <- SSE + SSR

R2   <- SSR/SST
chi2 <- n * R2
chi_c <- qchisq(1-alpha, k)
###############################################
# LINEARITAS (MODEL TERPILIH)
###############################################

y  <- as.matrix(data[,1])
X0 <- as.matrix(data[,c(2,3,4,5,7,9,13,14,15,17,18,20)])
n  <- nrow(y)
u  <- matrix(1, n, 1)
X  <- cbind(u, X0)

H   <- X%*%solve(t(X)%*%X)%*%t(X)
I   <- diag(1, n, n)
SSE0 <- t(y)%*%(I-H)%*%y

p <- ncol(X)
k <- p-1

yh  <- H%*%y
yh2 <- yh*yh
yh3 <- yh2*yh

X1 <- cbind(X, yh2, yh3)
q  <- ncol(X1)-ncol(X)+1

H1  <- X1%*%solve(t(X1)%*%X1, tol=1e-39)%*%t(X1)
SSE1 <- t(y)%*%(I-H1)%*%y

f1     <- (SSE0-SSE1)/(q-1)/(SSE1/(n-k-q))
fcrit  <- qf(1-alpha, q-1, n-k-q)
p_val1 <- 1 - pf(f1, q-1, n-k-q)
