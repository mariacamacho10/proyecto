part of 'app_bloc.dart';

@immutable
sealed class AppBlocEvent {}

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

class DeleteStudentEvent extends AppBlocEvent {
  final String studentId;

  DeleteStudentEvent(this.studentId);
}