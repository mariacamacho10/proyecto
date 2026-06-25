import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../feature/students/models/student_model.dart';
import '../../feature/register/models/annotation_model.dart';

part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  AppBloc() : super(AppBlocState.initial()) {
    on<AddAnnotationEvent>(_onAddAnnotation);
  }

  void _onAddAnnotation(AddAnnotationEvent event, Emitter<AppBlocState> emit) {
    print('🔥 EVENTO RECIBIDO EN BLOC');
    print('Student: ${event.studentName}');
    print('Ficha: ${event.ficha}');
    print('Text: ${event.text}');
    // 1. Buscar estudiante por ficha
    final existingStudent = state.students.where((s) => s.ficha == event.ficha);

    Student student;

    if (existingStudent.isEmpty) {
      // crear estudiante nuevo
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

    // 2. crear anotación
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
}
