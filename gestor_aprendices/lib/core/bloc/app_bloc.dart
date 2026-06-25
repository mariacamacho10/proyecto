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
  }

  // Registro desde la pantalla de registro (crea estudiante si no existe)
  void _onAddAnnotation(AddAnnotationEvent event, Emitter<AppBlocState> emit) {
    final existingStudent = state.students.where((s) => s.ficha == event.ficha);

    Student student;

    if (existingStudent.isEmpty) {
      student = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.studentName,
        ficha: event.ficha,
      );
      final updatedStudents = List<Student>.from(state.students)..add(student);
      emit(state.copyWith(students: updatedStudents));
    } else {
      student = existingStudent.first;
    }

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

  // Añadir anotación a estudiante existente desde el detalle
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

  // Editar nombre del estudiante
  void _onUpdateStudentName(
      UpdateStudentNameEvent event, Emitter<AppBlocState> emit) {
    final updatedStudents = state.students.map((s) {
      if (s.id == event.studentId) {
        return Student(id: s.id, name: event.newName, ficha: s.ficha);
      }
      return s;
    }).toList();

    emit(state.copyWith(students: updatedStudents));
  }

  // Editar texto de una anotación
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
}
