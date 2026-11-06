-- Полное создание и заполнение university.sqlite
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS groups;

CREATE TABLE groups (
    group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_name TEXT NOT NULL UNIQUE,
    course INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    group_id INTEGER,
    FOREIGN KEY (group_id) REFERENCES groups(group_id)
);
CREATE TABLE teachers (
    teacher_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    department TEXT NOT NULL
);
CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_name TEXT NOT NULL UNIQUE,
    hours INTEGER NOT NULL DEFAULT 36
);
CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    grade INTEGER NOT NULL CHECK (grade BETWEEN 2 AND 5),
    grade_date TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

INSERT INTO groups(group_name, course) VALUES
('ИС-21', 2), ('ИС-22', 1), ('ПМ-21', 2), ('ЭК-23', 1);

INSERT INTO students(last_name, first_name, group_id) VALUES
('Иванов','Алексей',1), ('Петрова','Мария',1), ('Сидоров','Дмитрий',1),
('Кузнецова','Анна',2), ('Смирнов','Игорь',2), ('Волкова','Елена',2),
('Морозов','Павел',3), ('Зайцева','Ольга',3), ('Лебедев','Никита',3),
('Козлова','Дарья',4), ('Новиков','Артём',4), ('Соколова','Виктория',1);

INSERT INTO teachers(last_name, first_name, middle_name, department) VALUES
('Андреева','Галина','Петровна','Информатика'),
('Борисов','Сергей','Иванович','Математика'),
('Ветрова','Наталья','Андреевна','Экономика'),
('Громов','Илья',NULL,'Информатика');

INSERT INTO subjects(subject_name, hours) VALUES
('Базы данных',72), ('Математический анализ',108), ('Программирование',90),
('Экономика',54), ('Английский язык',72);

INSERT INTO grades(student_id, subject_id, teacher_id, grade, grade_date) VALUES
(1,1,1,5,'2026-09-05'), (1,3,4,4,'2026-09-12'),
(2,1,1,4,'2026-09-05'), (2,2,2,5,'2026-09-08'),
(3,1,1,3,'2026-09-05'), (3,3,4,2,'2026-09-12'),
(4,1,1,5,'2026-09-06'), (4,2,2,5,'2026-09-09'),
(5,2,2,3,'2026-09-09'), (5,3,4,4,'2026-09-13'),
(6,1,1,4,'2026-09-06'), (7,2,2,4,'2026-09-10'),
(7,3,4,5,'2026-09-13'), (8,2,2,5,'2026-09-10'),
(9,3,4,3,'2026-09-14'), (10,4,3,4,'2026-09-11'),
(11,4,3,3,'2026-09-11'), (12,1,1,5,'2026-09-06'),
(12,2,2,4,'2026-09-10');

-- Модуль 5
-- 5А
SELECT subject_name, hours FROM subjects
WHERE hours > 60 ORDER BY hours DESC;
-- 5Б
SELECT s.last_name, s.first_name
FROM students s JOIN groups g ON g.group_id=s.group_id
WHERE g.group_name='ИС-21'
ORDER BY s.last_name, s.first_name;

-- Модуль 6
-- 6А
SELECT group_id, COUNT(*) AS student_count
FROM students GROUP BY group_id ORDER BY group_id;
-- 6Б
SELECT ROUND(AVG(grade),2) AS average_grade
FROM grades WHERE subject_id=1;

-- Модуль 7 / 7А
SELECT t.last_name, t.first_name, sub.subject_name,
       COUNT(gr.grade_id) AS grades_count
FROM grades gr
JOIN teachers t ON t.teacher_id=gr.teacher_id
JOIN subjects sub ON sub.subject_id=gr.subject_id
GROUP BY t.teacher_id, sub.subject_id
ORDER BY t.last_name, t.first_name, sub.subject_name;

-- Итоговое задание 1
SELECT g.group_name, COUNT(s.student_id) AS student_count
FROM groups g LEFT JOIN students s ON s.group_id=g.group_id
GROUP BY g.group_id, g.group_name
ORDER BY student_count DESC, g.group_name;

-- Итоговое задание 2
SELECT s.last_name, s.first_name, g.group_name,
       ROUND(AVG(gr.grade),2) AS average_grade
FROM students s
JOIN groups g ON g.group_id=s.group_id
JOIN grades gr ON gr.student_id=s.student_id
GROUP BY s.student_id, s.last_name, s.first_name, g.group_name
ORDER BY average_grade DESC, s.last_name, s.first_name;

-- Итоговое задание 3
SELECT s.last_name, s.first_name
FROM students s JOIN grades gr ON gr.student_id=s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING AVG(gr.grade)=5
ORDER BY s.last_name, s.first_name;

-- Итоговое задание 4
SELECT t.last_name, t.first_name, COUNT(gr.grade_id) AS grades_count
FROM teachers t JOIN grades gr ON gr.teacher_id=t.teacher_id
GROUP BY t.teacher_id, t.last_name, t.first_name
ORDER BY grades_count DESC LIMIT 1;

-- Дополнительный общий отчёт
SELECT s.last_name AS student, g.group_name AS student_group,
       sub.subject_name AS subject, t.last_name AS teacher,
       gr.grade, gr.grade_date
FROM grades gr
JOIN students s ON s.student_id=gr.student_id
JOIN groups g ON g.group_id=s.group_id
JOIN subjects sub ON sub.subject_id=gr.subject_id
JOIN teachers t ON t.teacher_id=gr.teacher_id
ORDER BY gr.grade_date;

-- Примеры модуля 8 (по отдельности, при необходимости):
-- UPDATE students SET group_id=2 WHERE student_id=3;
-- DELETE FROM grades WHERE grade_id=3;
