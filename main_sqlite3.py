import sqlite3

# Файл university.sqlite должен лежать рядом с main.py
with sqlite3.connect("university.sqlite") as con:
    con.execute("PRAGMA foreign_keys = ON")
    rows = con.execute("SELECT * FROM groups").fetchall()
    print(rows)
    for row in rows:
        print(row)
