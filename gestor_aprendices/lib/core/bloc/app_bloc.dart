import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../feature/register/models/annotation_model.dart';
import '../../feature/students/models/student_model.dart';

part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc() : super(AppBlocState.initial()) {
    on<AddAnnotationEvent>(_onAddAnnotation);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  void _onAddAnnotation(
    AddAnnotationEvent event,
    Emitter<AppBlocState> emit,
  ) {
    print('🔥 EVENTO RECIBIDO EN BLOC');
    print('Estudiante: ${event.studentName}');
    print('Ficha: ${event.ficha}');
    print('Anotación: ${event.text}');

    // Buscar estudiante por ficha
    final existingStudent = state.students.where(
      (student) => student.ficha == event.ficha,
    );

    Student student;

    if (existingStudent.isEmpty) {
      // Crear estudiante nuevo
      student = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.studentName,
        ficha: event.ficha,
      );

      final updatedStudents = List<Student>.from(state.students)
        ..add(student);

      print('✅ Nuevo estudiante creado');

      emit(
        state.copyWith(
          students: updatedStudents,
        ),
      );
    } else {
      student = existingStudent.first;

      print('ℹ️ Estudiante existente encontrado');
    }

    // Crear anotación
    final annotation = Annotation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      studentId: student.id,
      text: event.text,
      date: DateTime.now(),
    );

    final updatedAnnotations = List<Annotation>.from(
      state.annotations,
    )..add(annotation);

    print('✅ Anotación agregada');
    print('Total estudiantes: ${state.students.length}');
    print(
      'Total anotaciones: ${updatedAnnotations.length}',
    );

    emit(
      state.copyWith(
        annotations: updatedAnnotations,
      ),
    );
  }

  void _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<AppBlocState> emit,
  ) {
    print('🗑 Eliminando estudiante: ${event.studentId}');

    final updatedStudents = state.students
        .where(
          (student) => student.id != event.studentId,
        )
        .toList();

    final updatedAnnotations = state.annotations
        .where(
          (annotation) =>
              annotation.studentId != event.studentId,
        )
        .toList();

    print('✅ Estudiante eliminado');
    print(
      'Estudiantes restantes: ${updatedStudents.length}',
    );
    print(
      'Anotaciones restantes: ${updatedAnnotations.length}',
    );

    emit(
      state.copyWith(
        students: updatedStudents,
        annotations: updatedAnnotations,
      ),
    );
  }
}