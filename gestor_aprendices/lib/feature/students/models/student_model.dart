import 'dart:typed_data';

class Student {
  final String id;
  final String name;
  final String ficha;
  final Uint8List? imageBytes; // bytes de la foto (funciona en web y móvil)

  Student({
    required this.id,
    required this.name,
    required this.ficha,
    this.imageBytes,
  });

  Student copyWith({
    String? id,
    String? name,
    String? ficha,
    Uint8List? imageBytes,
    bool clearImage = false,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      ficha: ficha ?? this.ficha,
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'ficha': ficha,
      'imageBytes': imageBytes,
    };
  }

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      ficha: map['ficha'] as String,
      imageBytes: map['imageBytes'] as Uint8List?,
    );
  }
}
