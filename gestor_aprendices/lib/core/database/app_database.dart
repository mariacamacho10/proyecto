import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../feature/register/models/annotation_model.dart';
import '../../feature/students/models/student_model.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, 'gestor_aprendices.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        ficha TEXT NOT NULL,
        imageBytes BLOB
      )
    ''');

    await db.execute('''
      CREATE TABLE annotations(
        id TEXT PRIMARY KEY,
        studentId TEXT NOT NULL,
        text TEXT NOT NULL,
        date INTEGER NOT NULL,
        FOREIGN KEY(studentId) REFERENCES students(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final rows = await db.query('students');
    return rows.map(Student.fromMap).toList();
  }

  Future<List<Annotation>> getAnnotations() async {
    final db = await database;
    final rows = await db.query('annotations');
    return rows.map(Annotation.fromMap).toList();
  }

  Future<void> insertStudent(Student student) async {
    final db = await database;
    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAnnotation(Annotation annotation) async {
    final db = await database;
    await db.insert(
      'annotations',
      annotation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateStudent(Student student) async {
    final db = await database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> updateAnnotation(Annotation annotation) async {
    final db = await database;
    await db.update(
      'annotations',
      annotation.toMap(),
      where: 'id = ?',
      whereArgs: [annotation.id],
    );
  }

  Future<void> deleteStudents(List<String> studentIds) async {
    if (studentIds.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (final id in studentIds) {
      batch.delete('annotations', where: 'studentId = ?', whereArgs: [id]);
      batch.delete('students', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteAnnotation(String annotationId) async {
    final db = await database;
    await db.delete(
      'annotations',
      where: 'id = ?',
      whereArgs: [annotationId],
    );
  }
}
