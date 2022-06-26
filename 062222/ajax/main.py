from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/ajax_get")
def ajax_get():
    return jsonify({'name' : 'test'})

app.run