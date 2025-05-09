import 'package:flutter/material.dart';

class TapTransactionOptionScreen extends StatelessWidget {
  const TapTransactionOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones de Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOption(
              icon: Icons.add,
              text: 'Agregar registro',
              onTap: () {
                // Acción para agregar
              },
            ),
            const SizedBox(height: 16),
            _buildOption(
              icon: Icons.delete,
              text: 'Eliminar registro',
              onTap: () {
                // Accion para Eliminar
              },
            ),
            const SizedBox(height: 16),
            _buildOption(
              icon: Icons.cancel,
              text: 'Cancelar',
              onTap: () {
                Navigator.pop(context); // Cierra la pantalla actual
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
