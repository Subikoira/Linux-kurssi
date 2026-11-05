import os
import pymysql

from flask import Flask, make_response, render_template

app = Flask(__name__)


def avaa_tietokantayhteys():
    return pymysql.connect(
        host="localhost",
        user="viikko2app",
        password=os.environ["DB_PASSWORD"],
        database="viikko2",
        charset="utf8mb4",
        autocommit=False
    )


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/viikko2/")
def viikko2():
    connection = None

    try:
        connection = avaa_tietokantayhteys()

        with connection.cursor() as cursor:
            cursor.execute(
                "UPDATE laskuri SET kaynnit = kaynnit + 1 WHERE id = 1"
            )
            cursor.execute(
                "SELECT kaynnit FROM laskuri WHERE id = 1"
            )
            result = cursor.fetchone()

        connection.commit()
        kaynnit = result[0]

        return render_template(
            "viikko2.html",
            kaynnit=kaynnit
        )

    except Exception as error:
        if connection is not None:
            connection.rollback()

        app.logger.exception("Tietokantavirhe: %s", error)

        return make_response(
            "Kävijälaskurin tietokantayhteys epäonnistui.",
            500
        )

    finally:
        if connection is not None:
            connection.close()
