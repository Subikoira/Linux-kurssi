from flask import Flask, render_template

app = Flask(__name__)


@app.route("/")
def home():
	return render_template("index.html")

@app.route("/viikko2/")
def viikko2():
    return render_template("viikko2.html")
