import 'package:flutter/material.dart';

class Estudiante {
  final String nombre;
  final String ficha;
  final String ultimaAnotacion;
  bool seleccionado;

  Estudiante({
    required this.nombre,
    required this.ficha,
    required this.ultimaAnotacion,
    this.seleccionado = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void eliminarSeleccionados() {
    setState(() {
      estudiantes.removeWhere((e) => e.seleccionado);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Estudiantes eliminados correctamente"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seleccionados =
        estudiantes.where((e) => e.seleccionado).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          seleccionados > 0
              ? "$seleccionados seleccionados"
              : "Estudiantes",
        ),
        leading: IconButton(
          icon: const Icon(Icons.delete),
          onPressed:
              seleccionados > 0 ? eliminarSeleccionados : null,
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
      body: estudiantes.isEmpty
          ? const Center(
              child: Text(
                "No hay estudiantes registrados",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: estudiantes.length,
              itemBuilder: (context, index) {
                final estudiante = estudiantes[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: estudiante.seleccionado
                      ? Colors.blue.shade50
                      : null,
                  child: ListTile(
                    leading: Checkbox(
                      value: estudiante.seleccionado,
                      onChanged: (value) {
                        setState(() {
                          estudiante.seleccionado = value ?? false;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      estudiante.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                    onTap: () {
                      setState(() {
                        estudiante.seleccionado =
                            !estudiante.seleccionado;
                      });
                    },
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