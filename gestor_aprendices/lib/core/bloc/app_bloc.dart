import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../database/app_database.dart';
import '../../feature/students/models/student_model.dart';
import '../../feature/register/models/annotation_model.dart';

part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc() : super(AppBlocState.initial()) {
    on<LoadAppDataEvent>(_onLoadAppData);
    on<AddAnnotationEvent>(_onAddAnnotation);
    on<AddAnnotationToStudentEvent>(_onAddAnnotationToStudent);
    on<UpdateStudentNameEvent>(_onUpdateStudentName);
    on<UpdateAnnotationEvent>(_onUpdateAnnotation);
    on<UpdateStudentImageEvent>(_onUpdateStudentImage);
    on<DeleteStudentsEvent>(_onDeleteStudents);
    on<DeleteAnnotationEvent>(_onDeleteAnnotation);

    add(LoadAppDataEvent());
  }

  Future<void> _onLoadAppData(
      LoadAppDataEvent event, Emitter<AppBlocState> emit) async {
    final students = await AppDatabase.instance.getStudents();
    final annotations = await AppDatabase.instance.getAnnotations();
    emit(state.copyWith(students: students, annotations: annotations));
  }

  Future<void> _onAddAnnotation(
      AddAnnotationEvent event, Emitter<AppBlocState> emit) async {
    final student = Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.studentName,
      ficha: event.ficha,
    );
    await AppDatabase.instance.insertStudent(student);

    final annotation = Annotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: student.id,
      text: event.text,
      date: DateTime.now(),
    );
    await AppDatabase.instance.insertAnnotation(annotation);

    final updatedStudents = List<Student>.from(state.students)..add(student);
    final updatedAnnotations = List<Annotation>.from(state.annotations)
      ..add(annotation);
    emit(state.copyWith(
      students: updatedStudents,
      annotations: updatedAnnotations,
    ));
  }

  Future<void> _onAddAnnotationToStudent(
      AddAnnotationToStudentEvent event, Emitter<AppBlocState> emit) async {
    final annotation = Annotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: event.studentId,
      text: event.text,
      date: DateTime.now(),
    );
    await AppDatabase.instance.insertAnnotation(annotation);

    final updatedAnnotations = List<Annotation>.from(state.annotations)
      ..add(annotation);
    emit(state.copyWith(annotations: updatedAnnotations));
  }

  Future<void> _onUpdateStudentName(
      UpdateStudentNameEvent event, Emitter<AppBlocState> emit) async {
    final updatedStudents = state.students.map((s) {
      if (s.id == event.studentId) {
        final updated = s.copyWith(name: event.newName);
        AppDatabase.instance.updateStudent(updated);
        return updated;
      }
      return s;
    }).toList();
    emit(state.copyWith(students: updatedStudents));
  }

  Future<void> _onUpdateAnnotation(
      UpdateAnnotationEvent event, Emitter<AppBlocState> emit) async {
    final updatedAnnotations = state.annotations.map((a) {
      if (a.id == event.annotationId) {
        final updated = Annotation(
          id: a.id,
          studentId: a.studentId,
          text: event.newText,
          date: a.date,
        );
        AppDatabase.instance.updateAnnotation(updated);
        return updated;
      }
      return a;
    }).toList();
    emit(state.copyWith(annotations: updatedAnnotations));
  }

  Future<void> _onUpdateStudentImage(
      UpdateStudentImageEvent event, Emitter<AppBlocState> emit) async {
    final updatedStudents = state.students.map((s) {
      if (s.id == event.studentId) {
        final updated = s.copyWith(
          imageBytes: event.imageBytes,
          clearImage: event.imageBytes == null,
        );
        AppDatabase.instance.updateStudent(updated);
        return updated;
      }
      return s;
    }).toList();
    emit(state.copyWith(students: updatedStudents));
  }

  Future<void> _onDeleteStudents(
      DeleteStudentsEvent event, Emitter<AppBlocState> emit) async {
    await AppDatabase.instance.deleteStudents(event.studentIds);

    final updatedStudents = state.students
        .where((s) => !event.studentIds.contains(s.id))
        .toList();
    final updatedAnnotations = state.annotations
        .where((a) => !event.studentIds.contains(a.studentId))
        .toList();
    emit(state.copyWith(
      students: updatedStudents,
      annotations: updatedAnnotations,
    ));
  }

  Future<void> _onDeleteAnnotation(
      DeleteAnnotationEvent event, Emitter<AppBlocState> emit) async {
    await AppDatabase.instance.deleteAnnotation(event.annotationId);

    final updatedAnnotations = state.annotations
        .where((a) => a.id != event.annotationId)
        .toList();
    emit(state.copyWith(annotations: updatedAnnotations));
  }
}
