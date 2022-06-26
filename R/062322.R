name <- c("A", "B", "C", "D", "E")
grade <- c(1, 3, 2, 1, 2)
student <- data.frame(name, grade)
student

midterm <- c(70, 80, 60, 70, 90)
final <- c(80, 80, 70, 60, 60)
scores <- cbind(midterm, final)
scores

gender <- c("M", "F", "F", "F", "M")

## studnet -> dataframe
## scores -> dataframe
## gender -> vector

students <- data.frame(student, gender, scores)
students

## cbind() 함수는 컬럼을 추가하는 함수.
## total_score는 벡터 2개의 합. 컬럼X
total_score <- midterm + final
total_score
cbind(students, total_score)

## rbind() 함수. 행을 추가하는 함수
new_student <- data.frame(name = "F", grade =2,
                          gender = "M",
                          midterm = 90, final=80)
new_student
## students에 new_student을 결합
rbind(students, new_student)

## 컬럼 기준으로 출력
students$name
students[["grade"]]
students[[4]]
students[,"gender"]

## 인덱스 기준으로 출력
students[1,]
students[2:5,]
students[-2,]

## 필터링
students$midterm >= 80
students[students$midterm >= 80,]

## 오름차순, 내림차순 정렬
order(students$grade)
students[order(students$grade),]

order(students$midterm, decreasing = TRUE)
order(-students$midterm)
students[order(students$midterm, decreasing = TRUE),]


## 결측치인 NA 연산 관련
x <- c(7, 9, NA, 5, 2)
x[x>6]
x[x<6]
x[x==7]
subset(x, x>6)
subset(x, x<6)

read.csv("csv_exam.csv")

exam <- read.csv("csv_exam.csv")
head(exam)
head(exam, 3)

tail(exam)
tail(exam, 2)

## 데이터프레임을 엑셀의 시트와 같이 보여주는 함수
## view() : 앞 글자 V는 대문자
View(exam)

## 데이터프레임의 사이즈 출력. 행과 열
dim(exam)

## 데이터프레임의 속성 값 확인하는 함수 str()
str(exam)

## table()은 컬럼의 데이터들의 개수를 출력
table(exam$class)

## 통계 요약 함수 summary()
summary(exam)
summary(exam$math)

## 패키지 설치 dplyr
install.packages("dplyr")
## 패키지는 로드(python에서의 import와 같은 기능)
library(dplyr)

df_raw <- data.frame(var1 = c(1,2,1),
                     var2 = c(2,3,5))

df_raw

rename(df_raw, v2 = var2)

# 파생변수 생성
df_raw$sum <- df_raw$var1 + df_raw$var2
df_raw

# 조건문을 이용 파생변수 생성
# ifelse(조건식, 참인경우 부여될 값, 거짓인 경우 부여될 값)
df_raw$total <- ifelse(df_raw$sum > 5, "pass", "fail")
df_raw

# 조건식이 다중인 경우
df_raw$total <- ifelse(df_raw$sum > 5, "pass",
                       ifelse(df_raw$sum == 5, "hold",
                              "fail"))
df_raw

exam

# 파이프 연산자 단축키 ctrl + shift + m
# filter() - 필터링 기능
exam %>% filter(class == 1)

# arrange() - 특정 컬럼의 값을 기준으로 정렬하는 함수
exam %>%  arrange(math)

exam %>% arrange(math,english)
exam %>% arrange(desc(class), math)
exam %>% arrange(-class, math)

# 특정 컬럼만 제거
exam %>% select(-class)

# 컬럼의 범위 지정
exam %>% select(math:science)

# mutate() - 새로운 컬럼 추가
exam %>% mutate(total = math + english + science,
                mean = (math + english + science)/3)

# groupby() summarise() 동시사용
exam %>% group_by(class) %>% 
  summarise(math_mean = mean(math),
            english_mean = mean(english))

# join()
data.frame(id = 1:5, score = c(60,70, 80, 90, 95)) -> df_1
df_1
df_2 <- data.frame(id = 1:5, weight=c(80,70,75,65,60))
df_3 <- data.frame(id = 1:3, class = c(1,1,2))

# inner_join
inner_join(df_1, df_2, by="id")
inner_join(df_1, df_3, by="id")

# left_join
left_join(df_1, df_2, by="id")
left_join(df_1, df_3, by="id")

# right_join
right_join(df_1, df_2, by="id")
right_join(df_1, df_3, by="id")

# full_join
full_join(df_1, df_2, by="id")
full_join(df_1, df_3, by="id")

# bind_rows() 행 추가
a <- df_1
b <- df_2
bind_rows(a, b)
c <- data.frame(id = c(7,8,10), score=c(100, 80, 50))
bind_rows(a,c)

c1 <- c(1,2,NA,NA,5)
c2 <- c(1,2,3,4,5)
c3 <- c(NA,2,3,4,5)

df <- data.frame(c1, c2, c3)
df

is.na(df)
table(is.na(df))
table(df$c1)
is.na(df)

!is.na(df)
table(is.na(df$c1))
table(is.na(df$c2))
table(is.na(df$c3))

# 결측치 제거
df %>% filter(is.na(c1))
df %>% filter(!is.na(c1))

# na.omit() 행에 결측치가 존재하면 행 삭제
na.omit(df)

# na.rm = T를 이용하여 결측치를 제외하고 연산
mean(df$c1)
sum(df$c1)
mean(df$c1, na.rm = T)
sum(df$c1, na.rm = T)

# 결측치 추가
exam[c(5,7), 3] = NA
exam

# 결측치 대체가 안되는 코드
table(is.na(exam$math),
      mean(exam))
exam$math <- ifelse(is.na(exam$math),
                    mean(exam$math), exam$math)
table(is.na(exam$math))

# 결측치가 존재하는 컬럼에서 연산을 하려면
# na.rm = T를 이용하여 연산을 하여야 된다.
exam$math <- ifelse(is.na(exam$math),
                    mean(exam$math, na.rm = T), exam$math)
table(is.na(exam$math))
exam

# 이상치 데이터프레임 만들기
outlier <- data.frame(gender = c(1,2,1,3,2,1),
                      score = c(60,70,30,40,80,90))
# 이상치 체크
table(outlier$gender)

# 이상치 제거, ifelse를 이용하여 이상치를 NA로 변환
outlier$gender <- ifelse(outlier$gender == 3, NA,
                         outlier$gender)

# 이상치의 값이 NA 변환됐는지 확인
table(outlier$gender)

# 이상치를 제외한 성별 점수 평균 구하기
outlier %>% filter(!is.na(gender)) %>% 
  group_by(gender) %>% 
  summarise((score_mean = mean(score)))

library(ggplot2)
mpg
View(mpg)

mpg <- ggplot2::mpg
# 극단치 확인 박스 플롯 그래프
boxplot(mpg$hwy)
# 박스 플롯 그래프의 수치 출력
boxplot(mpg$hwy)$stats
table(is.na(mpg$hwy))

mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy > 37,
                 NA, mpg$hwy)
table(is.na(mpg$hwy))

# mpg 데이터에서 hwy기준으로 결측치가 아닌 값을 필터링
# manufacturer를 기준으로 그룹화
# hwy의 평균 값을 출력
# (dplyr 패키지를 사용해서 한줄로 처리)

mpg %>% filter(!is.na(hwy)) %>% 
        group_by(manufacturer) %>% 
          summarise(hwy_meam = mean(hwy))

mpg %>% group_by(manufacturer) %>% 
  summarise(hwy_mean = mean(hwy, na.rm=T))
        