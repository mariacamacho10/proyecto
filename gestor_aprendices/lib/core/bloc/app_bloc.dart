import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../feature/students/models/student_model.dart';
import '../../feature/register/models/annotation_model.dart';

part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc() : super(AppBlocState.initial()) {
    on<AddAnnotationEvent>(_onAddAnnotation);
    on<AddAnnotationToStudentEvent>(_onAddAnnotationToStudent);
    on<UpdateStudentNameEvent>(_onUpdateStudentName);
    on<UpdateAnnotationEvent>(_onUpdateAnnotation);
    on<UpdateStudentImageEvent>(_onUpdateStudentImage);
    on<DeleteStudentsEvent>(_onDeleteStudents);
    on<DeleteAnnotationEvent>(_onDeleteAnnotation);
  }

  void _onAddAnnotation(AddAnnotationEvent event, Emitter<AppBlocState> emit) {
    final student = Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.studentName,
      ficha: event.ficha,
    );
    final updatedStudents = List<Student>.from(state.students)..add(student);
    emit(state.copyWith(students: updatedStudents));

    final annotation = Annotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: student.id,
      text: event.text,
      date: DateTime.now(),
    );
    final updatedAnnotations = List<Annotation>.from(state.annotations)
      ..add(annotation);
    emit(state.copyWith(annotations: updatedAnnotations));
  }

  void _onAddAnnotationToStudent(
      AddAnnotationToStudentEvent event, Emitter<AppBlocState> emit) {
    final annotation = Annotation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: event.studentId,
      text: event.text,
      date: DateTime.now(),
    );
    final updatedAnnotations = List<Annotation>.from(state.annotations)
      ..add(annotation);
    emit(state.copyWith(annotations: updatedAnnotations));
  }

  void _onUpdateStudentName(
      UpdateStudentNameEvent event, Emitter<AppBlocState> emit) {
    final updatedStudents = state.students.map((s) {
      if (s.id == event.studentId) return s.copyWith(name: event.newName);
      return s;
    }).toList();
    emit(state.copyWith(students: updatedStudents));
  }

  void _onUpdateAnnotation(
      UpdateAnnotationEvent event, Emitter<AppBlocState> emit) {
    final updatedAnnotations = state.annotations.map((a) {
      if (a.id == event.annotationId) {
        return Annotation(
          id: a.id,
          studentId: a.studentId,
          text: event.newText,
          date: a.date,
        );
      }
      return a;
    }).toList();
    emit(state.copyWith(annotations: updatedAnnotations));
  }

  void _onUpdateStudentImage(
      UpdateStudentImageEvent event, Emitter<AppBlocState> emit) {
    final updatedStudents = state.students.map((s) {
      if (s.id == event.studentId) {
        return s.copyWith(
          imageBytes: event.imageBytes,
          clearImage: event.imageBytes == null,
        );
      }
      return s;
    }).toList();
    emit(state.copyWith(students: updatedStudents));
  }

  void _onDeleteStudents(
      DeleteStudentsEvent event, Emitter<AppBlocState> emit) {
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

  void _onDeleteAnnotation(
      DeleteAnnotationEvent event, Emitter<AppBlocState> emit) {
    final updatedAnnotations = state.annotations
        .where((a) => a.id != event.annotationId)
        .toList();
    emit(state.copyWith(annotations: updatedAnnotations));
  }
}
