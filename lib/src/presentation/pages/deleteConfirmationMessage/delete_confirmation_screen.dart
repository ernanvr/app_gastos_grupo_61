// src/presentation/pages/deleteConfirmationMessage/delete_confirmation_screen.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TransaccionEliminada());
  }
}

class TransaccionEliminada extends StatefulWidget {
  const TransaccionEliminada({super.key});

  @override
  _TransaccionEliminadaState createState() => _TransaccionEliminadaState();
}

class _TransaccionEliminadaState extends State<TransaccionEliminada> {
  // Variable para manejar el estado de la transacción
  String mensaje = '';
  bool eliminada = false;

  // Función para eliminar la transacción
  void eliminarTransaccion() {
    setState(() {
      eliminada = true;
      mensaje = 'Transacción eliminada correctamente';
    });
    // Redirigir a la página deseada después de eliminar
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(
        context,
        '/ruta-deseada',
      ); // <-- Cambia '/ruta-deseada' por la ruta a la que quieres redirigir
    });
  }

  // Función para cancelar la transacción
  void cancelarTransaccion() {
    setState(() {
      mensaje = 'Operación cancelada';
    });
    // Regresa a la pantalla anterior
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // <-- Esto regresa a la pantalla anterior
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacción')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mensaje de confirmación
            Text(
              mensaje,
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 20),
            // Botón para eliminar la transacción
            ElevatedButton(
              onPressed: eliminada ? null : eliminarTransaccion,
              child: const Text('Eliminar Transacción'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 10),
            // Botón para cancelar la transacción
            ElevatedButton(
              onPressed: cancelarTransaccion,
              child: const Text('Cancelar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
