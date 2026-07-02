import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_aprendices/core/bloc/app_bloc.dart';
import 'package:gestor_aprendices/feature/register/models/annotation_model.dart';
import 'package:gestor_aprendices/feature/register/views/register_anotations_view.dart';
import 'package:gestor_aprendices/feature/students/models/student_model.dart';
import 'package:gestor_aprendices/feature/students/views/student_detail_view.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

enum StudentSortOrder { none, ascending, descending }

class _StudentsViewState extends State<StudentsView> {
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;
  final Set<String> _selectedStudentIds = {};
  bool _selectionMode = false;
  bool _searchReadOnly = true;
  String _query = '';
  StudentSortOrder _sortOrder = StudentSortOrder.none;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Student> _filter(List<Student> students, List<Annotation> annotations) {
    final filtered = students.where((s) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.ficha.toLowerCase().contains(q);
    }).toList();

    if (_sortOrder == StudentSortOrder.none) {
      return filtered;
    }

    filtered.sort((a, b) {
      final aCount = annotations.where((x) => x.studentId == a.id).length;
      final bCount = annotations.where((x) => x.studentId == b.id).length;
      return _sortOrder == StudentSortOrder.ascending
          ? aCount.compareTo(bCount)
          : bCount.compareTo(aCount);
    });

    return filtered;
  }

  void _toggleSelectionMode([bool enabled = true]) {
    setState(() {
      _selectionMode = enabled;
      if (!enabled) {
        _selectedStudentIds.clear();
      }
    });
  }

  void _toggleStudentSelection(String studentId) {
    setState(() {
      if (_selectedStudentIds.contains(studentId)) {
        _selectedStudentIds.remove(studentId);
        if (_selectedStudentIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedStudentIds.add(studentId);
        _selectionMode = true;
      }
    });
  }

  Future<void> _confirmDeleteSelected() async {
    final selectedCount = _selectedStudentIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar estudiantes'),
          content: Text(
            '¿Eliminar $selectedCount estudiante'
            '${selectedCount == 1 ? '' : 's'}? '
            'También se eliminarán sus anotaciones.',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      context.read<AppBloc>().add(
        DeleteStudentsEvent(studentIds: _selectedStudentIds.toList()),
      );
      _toggleSelectionMode(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$selectedCount estudiante${selectedCount == 1 ? '' : 's'} eliminado${selectedCount == 1 ? '' : 's'}',
          ),
        ),
      );
    }
  }

  String _sortLabel(StudentSortOrder sort) {
    switch (sort) {
      case StudentSortOrder.ascending:
        return 'Menor a mayor';
      case StudentSortOrder.descending:
        return 'Mayor a menor';
      case StudentSortOrder.none:
        return 'Sin ordenar';
    }
  }

  void _activateSearchField() {
    if (_searchReadOnly) {
      setState(() {
        _searchReadOnly = false;
      });
      Future.microtask(() => _searchFocusNode.requestFocus());
    }
  }

  Future<void> _openSortDialog() async {
    final selected = await showDialog<StudentSortOrder>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Ordenar por anotaciones'),
          children: [
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, StudentSortOrder.descending),
              child: const Text('Mayor a menor'),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, StudentSortOrder.ascending),
              child: const Text('Menor a mayor'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, StudentSortOrder.none),
              child: const Text('Sin ordenar'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _sortOrder = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectionMode
            ? Text(
                '${_selectedStudentIds.length} seleccionado${_selectedStudentIds.length == 1 ? '' : 's'}',
              )
            : const Text('Aprendices'),
        leading: IconButton(
          icon: Icon(_selectionMode ? Icons.close : Icons.delete),
          onPressed: () {
            if (_selectionMode) {
              _toggleSelectionMode(false);
            } else {
              _toggleSelectionMode(true);
            }
          },
        ),
        actions: _selectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: _selectedStudentIds.isEmpty
                      ? null
                      : _confirmDeleteSelected,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // — Barra de búsqueda —
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              readOnly: _searchReadOnly,
              onTap: _activateSearchField,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o ficha...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Orden: ${_sortLabel(_sortOrder)}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openSortDialog,
                  icon: const Icon(Icons.sort),
                  label: const Text('Orden'),
                ),
              ],
            ),
          ),

          // — Lista —
          Expanded(
            child: BlocBuilder<AppBloc, AppBlocState>(
              builder: (context, state) {
                final filtered = _filter(state.students, state.annotations);

                if (state.students.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay aprendices registrados.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Usa el botón + para registrar una anotación.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 52,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sin resultados para "$_query"',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final student = filtered[index];
                    final annotationCount = state.annotations
                        .where((a) => a.studentId == student.id)
                        .length;

                    final studentAnnotations =
                        state.annotations
                            .where((a) => a.studentId == student.id)
                            .toList()
                          ..sort((a, b) => b.date.compareTo(a.date));
                    final latestAnnotation = studentAnnotations.isNotEmpty
                        ? studentAnnotations.first.text
                        : null;

                    final isSelected = _selectedStudentIds.contains(student.id);
                    return Card(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withAlpha(
                              (0.12 * 255).round(),
                            )
                          : null,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: _selectionMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    _toggleStudentSelection(student.id),
                              )
                            : CircleAvatar(
                                // Mostrar foto si existe, si no la letra inicial
                                backgroundImage: student.imageBytes != null
                                    ? MemoryImage(student.imageBytes!)
                                    : null,
                                child: student.imageBytes == null
                                    ? Text(
                                        student.name.isNotEmpty
                                            ? student.name[0].toUpperCase()
                                            : '?',
                                      )
                                    : null,
                              ),
                        title: Text(
                          student.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ficha: ${student.ficha}'),
                            if (latestAnnotation != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                latestAnnotation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            '$annotationCount '
                            '${annotationCount == 1 ? 'anotación' : 'anotaciones'}',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onLongPress: () {
                          if (!_selectionMode) {
                            _toggleSelectionMode(true);
                          }
                          _toggleStudentSelection(student.id);
                        },
                        onTap: () {
                          if (_selectionMode) {
                            _toggleStudentSelection(student.id);
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentDetailView(student: student),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterAnotationsView()),
          );
        },
        tooltip: 'Registrar anotación',
        child: const Icon(Icons.add),
      ),
    );
  }
}
