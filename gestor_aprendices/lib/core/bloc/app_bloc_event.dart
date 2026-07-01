part of 'app_bloc.dart';

@immutable
sealed class AppBlocEvent {}

class LoadAppDataEvent extends AppBlocEvent {}

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

// Actualizar foto de perfil (bytes, compatible con web y móvil)
class UpdateStudentImageEvent extends AppBlocEvent {
  final String studentId;
  final Uint8List? imageBytes;

  UpdateStudentImageEvent({
    required this.studentId,
    this.imageBytes,
  });
}

// Eliminar estudiantes seleccionados
class DeleteStudentsEvent extends AppBlocEvent {
  final List<String> studentIds;

  DeleteStudentsEvent({required this.studentIds});
}

// Eliminar una anotación
class DeleteAnnotationEvent extends AppBlocEvent {
  final String annotationId;

  DeleteAnnotationEvent({required this.annotationId});
}
