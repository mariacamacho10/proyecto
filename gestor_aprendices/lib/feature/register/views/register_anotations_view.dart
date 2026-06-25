import 'package:flutter/material.dart';

class RegisterAnotationsView extends StatefulWidget {
  const RegisterAnotationsView({super.key});

  @override
  State<RegisterAnotationsView> createState() => _RegisterAnotationsViewState();
}

class _RegisterAnotationsViewState extends State<RegisterAnotationsView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fichaController = TextEditingController();
  final TextEditingController annotationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    fichaController.dispose();
    annotationController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anotación guardada correctamente')),
      );

      nameController.clear();
      fichaController.clear();
      annotationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar anotación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del aprendiz',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: fichaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ficha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La ficha es obligatoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: annotationController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Anotación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La anotación es obligatoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Guardar'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
