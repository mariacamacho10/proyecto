import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestor_aprendices/core/bloc/app_bloc.dart';
import 'package:gestor_aprendices/feature/students/models/student_model.dart';

class StudentDetailView extends StatefulWidget {
  final Student student;

  const StudentDetailView({super.key, required this.student});

  @override
  State<StudentDetailView> createState() => _StudentDetailViewState();
}

class _StudentDetailViewState extends State<StudentDetailView> {
  final ImagePicker _picker = ImagePicker();

  // — Seleccionar foto (compatible web + móvil usando bytes) —
  Future<void> _pickImage(Student currentStudent) async {
    final option = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seleccionar foto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.photo_library)),
              title: const Text('Galería / Archivos'),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            if (currentStudent.imageBytes != null)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
                title: const Text(
                  'Quitar foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (option == null || !mounted) return;

    if (option == 'remove') {
      context.read<AppBloc>().add(
            UpdateStudentImageEvent(
                studentId: currentStudent.id, imageBytes: null),
          );
      return;
    }

    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file != null && mounted) {
      final bytes = await file.readAsBytes();
      if (mounted) {
        context.read<AppBloc>().add(
              UpdateStudentImageEvent(
                studentId: currentStudent.id,
                imageBytes: bytes,
              ),
            );
      }
    }
  }

  // — Diálogo: añadir nueva anotación —
  void _showAddAnnotationDialog(String studentId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva anotación'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Escribe la anotación...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  context.read<AppBloc>().add(
                        AddAnnotationToStudentEvent(
                            studentId: studentId, text: text),
                      );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Guardar'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  // — Diálogo: editar nombre —
  void _showEditNameDialog(Student s) {
    final controller = TextEditingController(text: s.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty && newName != s.name) {
                  context.read<AppBloc>().add(
                        UpdateStudentNameEvent(
                            studentId: s.id, newName: newName),
                      );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  // — Diálogo: editar anotación —
  void _showEditAnnotationDialog(String annotationId, String currentText) {
    final controller = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar anotación'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newText = controller.text.trim();
                if (newText.isNotEmpty && newText != currentText) {
                  context.read<AppBloc>().add(
                        UpdateAnnotationEvent(
                            annotationId: annotationId, newText: newText),
                      );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  // — Diálogo: confirmar eliminación de anotación —
  void _confirmDeleteAnnotation(String annotationId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar anotación'),
        content: const Text(
          '¿Seguro que quieres eliminar esta anotación? Esta acción no se puede deshacer.',
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<AppBloc>().add(
                      DeleteAnnotationEvent(annotationId: annotationId),
                    );
                Navigator.pop(ctx);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del aprendiz')),
      body: BlocBuilder<AppBloc, AppBlocState>(
        builder: (context, state) {
          final currentStudent = state.students.firstWhere(
            (s) => s.id == widget.student.id,
            orElse: () => widget.student,
          );

          final annotations = state.annotations
              .where((a) => a.studentId == widget.student.id)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // — Tarjeta del estudiante —
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(currentStudent),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundImage: currentStudent.imageBytes != null
                                ? MemoryImage(currentStudent.imageBytes!)
                                : null,
                            child: currentStudent.imageBytes == null
                                ? Text(
                                    currentStudent.name.isNotEmpty
                                        ? currentStudent.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentStudent.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ficha: ${currentStudent.ficha}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Editar nombre',
                      onPressed: () => _showEditNameDialog(currentStudent),
                    ),
                  ],
                ),
              ),

              // — Encabezado historial —
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 6),
                    Text('Historial de anotaciones',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Text('${annotations.length} total',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // — Lista anotaciones —
              Expanded(
                child: annotations.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notes_outlined,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No hay anotaciones aún.',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text('Usa el botón + para agregar una.',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: annotations.length,
                        itemBuilder: (context, index) {
                          final annotation = annotations[index];
                          final date = annotation.date;
                          final formattedDate =
                              '${date.day.toString().padLeft(2, '0')}/'
                              '${date.month.toString().padLeft(2, '0')}/'
                              '${date.year}  '
                              '${date.hour.toString().padLeft(2, '0')}:'
                              '${date.minute.toString().padLeft(2, '0')}';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 12, 8, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 13, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        formattedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      // Botón editar
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined,
                                            size: 18),
                                        tooltip: 'Editar anotación',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () =>
                                            _showEditAnnotationDialog(
                                          annotation.id,
                                          annotation.text,
                                        ),
                                      ),
                                      // Botón eliminar
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Eliminar anotación',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () =>
                                            _confirmDeleteAnnotation(
                                                annotation.id),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(annotation.text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAnnotationDialog(widget.student.id),
        tooltip: 'Añadir anotación',
        child: const Icon(Icons.add),
      ),
    );
  }
}
