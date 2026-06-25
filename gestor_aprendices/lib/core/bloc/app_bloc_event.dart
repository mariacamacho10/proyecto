part of 'app_bloc.dart';

@immutable
sealed class AppBlocEvent {}

// Crear anotación + estudiante si no existe (desde RegisterAnotationsView)
class AddAnnotationEvent extends AppBlocEvent {
  final String studentName;
  final String ficha;
  final String text;

  AddAnnotationEvent({
    required this.studentName,
    required this.ficha,
    required this.text,
  });
}

// Añadir anotación a un estudiante ya existente (desde StudentDetailView)
class AddAnnotationToStudentEvent extends AppBlocEvent {
  final String studentId;
  final String text;

  AddAnnotationToStudentEvent({
    required this.studentId,
    required this.text,
  });
}

// Editar el nombre de un estudiante
class UpdateStudentNameEvent extends AppBlocEvent {
  final String studentId;
  final String newName;

  UpdateStudentNameEvent({
    required this.studentId,
    required this.newName,
  });
}

// Editar el texto de una anotación existente
class UpdateAnnotationEvent extends AppBlocEvent {
  final String annotationId;
  final String newText;

  UpdateAnnotationEvent({
    required this.annotationId,
    required this.newText,
  });
}
