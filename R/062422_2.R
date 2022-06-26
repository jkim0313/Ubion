library(dplyr)
library(ggplot2)

mpg <- ggplot2::mpg

# dplyr 패키지를 이용해서
# total이라는 파생변수를 생성
#  cty, hwy 두 값의 평균 삽입

# case1
mpg$total = (mpg$cty+mpg$hwy)/2
mpg[,:(cty, hwy, total)]

# case2
mpg %>% mutate(total = (cty+hwy)/2) %>% 
                 select(cty, hwy, total) %>% head()

# total 컬럼을 생성. (평균 연비)
# total 데이터의 값을 가지고 test 파생변수 생성
# total의 값이 30이상이면 A
# 20이상 30미만이면 B
# 그 외는 C

# case1(dplyr)
mpg %>% mutate(test = ifelse(total >= 30, "A",
                        ifelse(total >= 20, "B", "C"))) %>% 
  select("total", "test") %>% head(5)
# case2(base)
mpg$test <- ifelse(mpg$total >= 30, "A",
                   ifelse(mpg$total >= 20, "B", "C"))
head(mpg[c("total", "test")], 5)

table(mpg$test)

## 실제 보고서용 시각화에는 잘 사용하지 않는 시각화 방법
qplot(mpg$test)

# str() - 데이터프레임 구조 확인
str(midwest)

View(midwest)
midwest <- as.data.frame(ggplot2::midwest)
str(midwest)

## midwest 데이터프레임에 poptotal 컬럼이름을 total로 변경
## popasian 컬럼이름을 asian으로 변경
## total, asian을 이용하여 전체 인구 대비 아시아 인구
## 백분율 값을 가지는 파생변수 ratio를 생성
## ratio 컬럼의 평균값을 초과하면 large 이하면 small
## 이라는 값을 가지는 파생변수 group 생성
## group컬럼의 해당하는 지역 개수 출력
## qplot 그래프로 시각화

midwest <- rename(midwest, total = poptotal)
midwest <- rename(midwest, asian = popasian)

# midwest <- midwest %>% mutate(ratio = (asian/total)*100)
midwest$ratio <- (midwest$asian / midwest$total) * 100

midwest$group <- ifelse(midwest$ratio > mean(midwest$ratio), "large", "small")

table(midwest$group)

qplot(midwest$group)

exam <- read.csv("csv_exam.csv")
## summarise()에서 사용하는 함수
## mean() : 평균
## sum() : 합계
## min() : 최소값
## max() : 최대값
## median() : 중앙값
## sd() : 표준편차
## n() : 빈도(개수)
exam %>% group_by(class) %>% summarise(
  mean = mean(math),
  sum = sum(math),
  min = min(math),
  max = max(math),
  median = median(math),
  sd = sd(math),
  n = n()
)

## mpg에서 manufacturer(제조사)별로 그룹화 
## class 값이 suv인 자동차들의 
## total 컬럼의 평균을 컬럼의 이름을 mean_total이라 지정
## 상위 5위까지 출력
mpg %>% group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  summarise(mean_total = mean(total)) %>% 
  arrange(desc(mean_total)) %>% 
  head(5)

mpg2 <- mpg %>% group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  summarise(mean_total = mean(total))
order(mpg2$mean_total)
head(mpg2[order(mpg2$mean_total, decreasing = TRUE),],5)

## mpg 데이터프레임은 연료 종류(f1) 컬럼이 존재
## 연료 가격을 나타내는 컬럼은 존재하지 않는다.
## 연료 종류, 연료 가격이 있는 데이터 프레임 만들고
## mpg 데이터프레임 join
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22))
fuel

## join() 함수를 사용해서 mpg, fuel 두 데이터프레임 결합
## mpg에 fuel 결합 join함수 종류 4개 중에 어떤 함수를 사용할지

table(mpg$fl)
add_mpg <- left_join(mpg, fuel, by="fl")
add_mpg %>%  select("fl", "price_fl") %>% head(5)

midwest <- as.data.frame(ggplot2::midwest)

## midwest 안에 popadults 컬럼 해당 지역의 성인 인구수
## poptotal은 해당 지역의 총 인구수
## "전체 인구수 대비 미성년자의 인구 백분율'을 ratio_child 파생변수 생성
## 미성년의 비율이 40% 이상이면 large
## 30%이상 40% 미만이면 middle
## 그 외에는 small
## 의 값을 가지는 grade 파생변수 생성
## 각 grade별 빈도수 출력, 막대그래프로 표시

midwest$ratio_child <- ((midwest$poptotal-midwest$popadults)/midwest$poptotal)*100
midwest$ratio_child

midwest$grade <- ifelse(midwest$ratio_child >= 40, "large",
                        ifelse(midwest$ratio_child >= 30, "middle", "small"))
midwest %>% group_by(grade) %>% 
  summarise(n())

table(midwest$grade)
ggplot(data=midwest, aes(x=grade)) + geom_bar()

## mpg, 데이터 초기화
mpg <- as.data.frame(ggplot2::mpg)
## 결측치 대입
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA

## drv 별로 hwy 평균을 구하려고 한다.
## 1. hwy 결측치 확인
## 2. filter를 이용해서 결측치를 제거한다.
## 3. drv별 hwy의 평균값을 구하고 상위를 기준으로 정렬

table(is.na(mpg$hwy))
table(is.na(mpg$drv))
table(is.na(mpg))
dim(mpg)
str(mpg)

mpg %>% filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(hwy_mean = mean(hwy)) %>% 
  arrange(desc(hwy_mean))

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10,14,58,93), "drv"] <- "k"
mpg[c(29,49,129,203), "cty"] <- c(3,4,39,42)

# drv 컬럼에 이상치 존재하는지 확인
# (4, f, r 정상 그 외 이상치)
# drv 이상치를 NA 대체 (k인경우 / 4, f, r이 아닌 경우)
# boxplot cty의 극단치를 체크를 하고
# 극단치도 NA로 대체
# 이상치와 극단치를 제거하고 drv별 cty 평균 값을 출력

table(mpg$drv)

mpg$drv <- ifelse(mpg$drv == "k", NA, mpg$drv)
# mpg$drv <- ifelse(mpg$drv %in% c("4", "f", "r"),
#                  mpg$drv, NA)

boxplot(mpg$cty)
boxplot(mpg$cty)$stats

mpg$cty <- ifelse(mpg$cty < 9 | mpg$cty > 26, NA, mpg$cty)

table(is.na(mpt$drv))
table(is.na(mpg$cty))

mpg %>% filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(cty_mean = mean(cty))
