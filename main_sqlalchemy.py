from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.orm import Session, DeclarativeBase, relationship

engine = create_engine("sqlite:///university.sqlite")

class Base(DeclarativeBase):
    pass

class Groups(Base):
    __tablename__ = "groups"
    group_id = Column(Integer, primary_key=True, index=True)
    group_name = Column(String, nullable=False)
    course = Column(Integer)
    students = relationship("Students", back_populates="group")

class Students(Base):
    __tablename__ = "students"
    student_id = Column(Integer, primary_key=True, index=True)
    last_name = Column(String)
    first_name = Column(String)
    group_id = Column(Integer, ForeignKey("groups.group_id"))
    group = relationship("Groups", back_populates="students")

# Таблицы уже созданы SQL-скриптом; create_all не удаляет существующие данные.
Base.metadata.create_all(engine)

with Session(engine) as db:
    groups = db.query(Groups).all()
    for group in groups:
        print(f"ID:{group.group_id} Название группы: {group.group_name} Курс: {group.course}")

    students = db.query(Students).all()
    for student in students:
        print(
            f"ID:{student.student_id} ФИ: {student.last_name} {student.first_name} "
            f"Группа: {student.group.group_name if student.group else 'не указана'}"
        )
