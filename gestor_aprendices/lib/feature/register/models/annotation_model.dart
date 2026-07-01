class Annotation {
  final String id;
  final String studentId;
  final String text;
  final DateTime date;

  Annotation({
    required this.id,
    required this.studentId,
    required this.text,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'text': text,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Annotation.fromMap(Map<String, Object?> map) {
    return Annotation(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      text: map['text'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }
}
