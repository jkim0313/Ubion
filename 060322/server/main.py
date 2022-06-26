from flask import Flask, render_template, request

app = Flask(__name__)

#web -> address(url), localhost:5000
@app.route("/")
def index():
    return "Hello World"

#localhost:5000/second로 접속시 바로 아래 함수가 실행
@app.route("/second")   
def second():
    return "Second page"

@app.route("/img")
def img():
    return render_template("07_img.html")

#localhost:5000/login 접속(request) -> login.html을 rendering한다.
@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/login2")
def login2():
    _id = request.args.get("id")
    _pass = request.args.get("pass")
    
    print(request.args.get("id"))
    print(request.args.get("pass"))
    
    if (_id == "test" and _pass == "1234"):
        return("정상적으로 로그인됐습니다.")
    else:
        return("아이디 또는 비밀번호가 틀렸습니다.")



app.run