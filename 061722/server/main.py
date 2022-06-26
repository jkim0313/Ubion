## 웹서버 오픈 사용할 라이브러리(flask) import 

import mimetypes
from flask import Flask, render_template, request, url_for, redirect, send_file, jsonify
import mod_sql
from io import BytesIO
import random
import pandas as pd
import matplotlib.pyplot as plt
import simplejson

# class인 Flask안에 __init__ 함수에는 self를 제외한 매개변수 1개는 존재
app = Flask(__name__)

# localhost:5000/ 에 접속할 때 바로 밑에 있는 함수를 실행
@app.route("/")
def index():
    return render_template("login.html").encode('UTF8')   
## localhost:5000/이라는 주소로 서버에 요청을 보내면
## "Hello, World"" 라는 문자를 바로 응답해준다

## 회원가입 페이지
@app.route("/signup")
def signup():
    return render_template("signup.html")
## localhost:5000/signup 이라는 주소로 서버에 요청을 보내면
## signup.html을 렌더링한다.

## localhost:5000/signup2로 요청이 들어오는데 요청의 형식이 POST인 경우 (기본은 GET)
@app.route("/signup2/", methods=["POST"])
def signup2():
    ## signup page에서 _id, _pass, _name 받아오는 작업
    ## post 형식에서는 데이터를 body 라는 곳에 담아서 서버에 요청
    ## get 형식에서는 url에 데이터를 담아서 보낸다.
    ## 서버와의 요청 방식은 데이터를 딕셔너리 형태로 보내준다.
    ## GET 형식에서는 request 안에 args에 데이터가 저장
    ## POST 형식에서는 request 안에 form에 데이터가 저장
    _id = request.form["_id"]
    _pass = request.form["_pass"]
    _name = request.form["_name"]
    sql = """ 
        INSERT INTO user VALUES (%s, %s, %s)
    """
    values = [_id, _pass, _name]
    _db = mod_sql.Database()
    _db.execute(sql, values)
    _db.commit()
    _db.close()
    
    print(_id, _pass, _name)
    return redirect(url_for('index'))

@app.route("/signin", methods=["POST"])
def signin():
    _id = request.form["_id"]
    _pass = request.form["_pass"]
    sql = """ 
        SELECT * FROM user WHERE id = %s AND pass = %s
    """
    values = [_id, _pass]
    _db = mod_sql.Database()
    result = _db.executeAll(sql, values)
    
    if result:
        return render_template("main.html")
    else:
        return redirect(url_for('index'))
    
    # return redirect(url_for('index'))

@app.route("/game", methods=["POST"])
def game():
    _use = request.form["use"]
    list_ = ["가위", "바위", "보"]
    choicelist = random.choice(list_)
    
    if _use == choicelist:
        return jsonify({'result' : '무승부'})
    if _use == "가위":
        if choicelist == "바위":
            return jsonify({'result' : '패배'})
        else:
            return jsonify({'result' : '승리'})
    if _use == "바위":
        if choicelist == "보":
            return jsonify({'result' : '패배'})
        else:
            return jsonify({'result' : '승리'})    
    else:
        if choicelist == "가위":
            return jsonify({'result' : '패배'})
        else:
            return jsonify({'result' : '승리'})
        
@app.route("/corona")
def corona():
    df = pd.read_csv("./csv/corona.csv")
    df.columns = ["인덱스", "등록일시", "사망자",
                  "확진자", "게시글번호", "기준일",
                  "기준시간", "수정일시", "누적의심자",
                  "누적확진률"]
    df.sort_values("등록일시", inplace=True)
    df["일일사망자"] = df["사망자"].diff().fillna(0)
    decide_data = df["일일사망자"].tolist()
    plt.plot(decide_data)
    img = BytesIO()
    plt.savefig(img, format="png", dpi=200)
    img.seek(0)

    return send_file(img, mimetype='imgae/png')      

@app.route("/graph")
def graph():
    df = pd.read_csv("./csv/corona.csv")
    df.columns = ["인덱스", "등록일시", "사망자",
                  "확진자", "게시글번호", "기준일",
                  "기준시간", "수정일시", "누적의심자",
                  "누적확진률"]
    df.sort_values("등록일시", inplace=True)
    df["일일사망자"] = df["사망자"].head(50).diff().fillna(0)
    decide_data = df["일일사망자"].head(50).tolist()
    date_list = df["등록일시"].head(50).tolist()
    cnt = len(date_list)
    print(cnt)
    df["일일확진자"] = df["확진자"].head(50).diff().fillna(0)
    inf = df["일일확진자"].head(50).tolist()
    # return render_template("graph.html")
    return render_template("dashboard.html", decide = decide_data, 
                           date_list = date_list, cnt = cnt, inf=inf)

@app.route("/graph2")
def graph2():
    try:
        sql = """ 
            SELECT `Item Type`,
            AVG(`Units Sold`) as AVG,
            SUM(`Units Sold`) as SUM
            FROM sales 
            GROUP BY `Item Type` 
            ORDER BY `Item Type`       
        """
        _db = mod_sql.Database()
        ## result에서 Decimal부분 그냥 숫자의 형태로 변경
        ## simplejson dict형 데이터를 str형으로 변환 -> 다시 dict 형태로 변경
        ## simplejson.dumps() dict형을 str형으로 변환
        ## eval()은 str형을 dict형으로 변환
        result = eval(simplejson.dumps(_db.executeAll(sql)))
        print("result ", result)
        
        item_type = []
        sold_avg = []
        sold_sum = []
        for i in result:
            item_type.append(i["Item Type"])
            sold_avg.append(i["AVG"])
            sold_sum.append(i["SUM"])
        print("item_type = ", item_type)
        print("sold_avg = ", sold_avg)
        print("sold_sum = ", sold_sum)
    
    finally:
        return render_template("dashboard2.html", t = result, x = item_type, 
                            y1 = sold_avg, y2 = sold_sum)    

## dashboard2.html 파일은
## t에는 전체 데이터의 값(dict)
## x에는 그래프에서 x축의 기준이 되는 값
## y1, y2에는 그래프에서 y축의 기준이 되는 값
## chartjs에서 x와 y1, y2의 값을 기준으로 해서 그래프 생성
## t라는 값이 지금은 컬럼이 3개 기준
## 이 부분은 테이블의 컬럼 개수와 상관없이 들어갈 수 있도록 수정
## t안에 컬럼의 개수에 상관없이 테이블 완성

@app.route("/graph3")
def graph3():
    df = pd.read_csv("./csv/drinks.csv")
    ## continent 결측치 존재. 이 결측치를 'OT'로 변경
    df["continent"] = df["continent"].fillna('OT')
    ## continent 그룹화, spirit_servings 평균, 합계
    result = df.groupby('continent').spirit_servings.agg(['mean', 'sum'])
    result_x = result.index.tolist()
    result_y1 = result["mean"].tolist()
    result_y2 = result["sum"].tolist()
    print(result_x, result_y1, result_y2)
    result_dict = result.to_dict()
    print(result_dict)
    return render_template('dashboard2.html',
    t = result_dict, x = result_x, y1= result_y1, y2 = result_y2)
    

@app.route("/html")
def html():
    return render_template("index.html")

app.run

## localhost:5000/second
# @app.route("/second")
# def second():
    # return "Second Page"
## localhost:5000/second 요청이 들어오면
## 'Second Page'라는 문자를 응답

## html이 응답
## flask 라이브러리 안에있는 render_template 필요