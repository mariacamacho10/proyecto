import 'package:flutter/material.dart';

class Estudiante {
  final String nombre;
  final String ficha;
  final String ultimaAnotacion;

  Estudiante({
    required this.nombre,
    required this.ficha,
    required this.ultimaAnotacion,
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Estudiante> estudiantes = [
    Estudiante(
      nombre: "Juan Pérez",
      ficha: "2876541",
      ultimaAnotacion: "Excelente participación en clase.",
    ),
    Estudiante(
      nombre: "María Gómez",
      ficha: "2876542",
      ultimaAnotacion: "Pendiente entrega de actividad.",
    ),
    Estudiante(
      nombre: "Carlos Rodríguez",
      ficha: "2876543",
      ultimaAnotacion: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estudiantes"),
        leading: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Acción eliminar
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Acción filtrar
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: estudiantes.length,
        itemBuilder: (context, index) {
          final estudiante = estudiantes[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                estudiante.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text("Ficha: ${estudiante.ficha}"),
                  const SizedBox(height: 4),
                  Text(
                    estudiante.ultimaAnotacion.isEmpty
                        ? "Sin anotaciones"
                        : estudiante.ultimaAnotacion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Registrar nueva anotación
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}