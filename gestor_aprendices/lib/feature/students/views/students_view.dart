import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestor_aprendices/core/bloc/app_bloc.dart';
import 'package:gestor_aprendices/feature/register/views/register_anotations_view.dart';
import 'package:gestor_aprendices/feature/students/models/student_model.dart';
import 'package:gestor_aprendices/feature/students/views/student_detail_view.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Student> _filter(List<Student> students) {
    if (_query.isEmpty) return students;
    final q = _query.toLowerCase();
    return students.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.ficha.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendices'),
      ),
      body: Column(
        children: [
          // — Barra de búsqueda —
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
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

          // — Lista —
          Expanded(
            child: BlocBuilder<AppBloc, AppBlocState>(
              builder: (context, state) {
                final filtered = _filter(state.students);

                if (state.students.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey),
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
                        const Icon(Icons.search_off,
                            size: 52, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Sin resultados para "$_query"',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 15),
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

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            student.name.isNotEmpty
                                ? student.name[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Ficha: ${student.ficha}'),
                        trailing: Chip(
                          label: Text(
                            '$annotationCount '
                            '${annotationCount == 1 ? 'anotación' : 'anotaciones'}',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onTap: () {
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
            MaterialPageRoute(
              builder: (_) => const RegisterAnotationsView(),
            ),
          );
        },
        tooltip: 'Registrar anotación',
        child: const Icon(Icons.add),
      ),
    );
  }
}
