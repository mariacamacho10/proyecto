part of 'app_bloc.dart';

@immutable
sealed class AppBlocEvent {}

// crear anotación + estudiante si no existe
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
