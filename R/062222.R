a <- c(1,2,3,4,5,6,7,8,9)
a
b <- array(1:20, dim=c(4,5))
b
c <- matrix(1:10, nrow=2)
c
list_ <- list(name = "test", age=20, phone="0123456789")
list_
list_["name"]

df <- data.frame(name = c("test", "test2"),
                 phone = c("010123456798", 
                           "01098765432"))
df

a <- matrix(1:10, nrow=2)
b <- matrix(1:10, nrow=5)
a %*% b

c <- 1:3
d <- 2:4
c %in% d


"%s%" <- function(x, y){
  return ((x+y)^2)
}
1 %s% 5

a <- 10
if (a > 20){
  print("a는 20보다 크다")
}else{
  print("a는 20보다 작거나 같다.")
}

name <- c("test", "test2","test3")
which(name == "test2")
which(name != "test")

a <- 1:10
for(i in a){
  if(i < 5){
    next
  }
  print(i)
}

func_1 <- function(){
  print("Hello R")
}

func_1()

func_2 <- function(x, y){
  return (x+y)
}

func_2(10, 20)

func_3 <- function(x, y=5){
  return (x-y)
}

func_3(10,2)
func_3(10)

func_4 <- function(x, ...){
  print(x)
  summary(...)
}

v <- 1:10

func_4("test", v)



