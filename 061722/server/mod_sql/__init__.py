## sql 모듈 생성
## 1. class Database() 생성
## 2. class 생성이 될 때 pymysql.connect()함수를 사용해서 DB의 정보를 입력
## 3. __init__() 함수를 제외하고 함수 3개를 생성
## 4. execute() 함수 -> 매개변수 sql, values를 생성. sql문 실행 
##                  -> values 값을 넣어서 실행
## 5. executeALL() 함수 -> 매개변수 sql, values를 생성. sql문 실행 
##                      -> values 값을 넣어서 실행
##                      -> 결과값 받아와서 데이터프레임으로 변경 후 리턴
## 6. commit() 함수 -> DB에 commit 과정
## 7. execute(), executeALL() 함수에서 매개변수 values 기본값을 비어있는 []
## 리스트 형태로 지정

import pymysql
import pandas as pd

class Database():
    def __init__(self):
        self._db = pymysql.connect(
            host = 'localhost',
            user = 'root',
            passwd = '0000',
            db = 'ubion4',
            port = 3306
        )
        
        self.cursor = self._db.cursor(pymysql.cursors.DictCursor)
    
    def execute(self, sql, values):
        self.cursor.execute(sql, values)
    
    def executeAll(self, sql, values=[]):
        self.cursor.execute(sql, values)            # 쿼리문 실행
        
        self.result = self.cursor.fetchall()        # 결과값을 받아온다
        # return pd.DataFrame(self.result)          # 결과값을 데이터프레임으로 변경 후 리턴
        return self.result
        
    def commit(self):
        self._db.commit()                           # DB에 적용 
        
    def close(self):
        self._db.close()    
        
def test(_x, _y):
    result = _x + _y
    return result