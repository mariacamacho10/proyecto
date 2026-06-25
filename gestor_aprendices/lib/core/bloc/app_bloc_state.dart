part of 'app_bloc.dart';

@immutable
class AppBlocState {
  final List<Student> students;
  final List<Annotation> annotations;

  const AppBlocState({
    required this.students,
    required this.annotations,
  });

  factory AppBlocState.initial() {
    return const AppBlocState(
      students: [],
      annotations: [],
    );
  }

  AppBlocState copyWith({
    List<Student>? students,
    List<Annotation>? annotations,
  }) {
    return AppBlocState(
      students: students ?? this.students,
      annotations: annotations ?? this.annotations,
    );
  }
}