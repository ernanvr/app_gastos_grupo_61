// src/presentation/pages/successNotification/success_notification_screen.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotificationDemo(),
    );
  }
}

class NotificationDemo extends StatefulWidget {
  const NotificationDemo({super.key});

  @override
  _NotificationDemoState createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  bool _showNotification = false;

  // Función para mostrar la notificación
  void showSuccessNotification() {
    setState(() {
      _showNotification = true;
    });

    // Temporizador para ocultar la notificación después de 10 segundos
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificación de Transacción')),
      body: Center(
        child: ElevatedButton(
          onPressed: showSuccessNotification,
          child: const Text("Guardar Transacción"),
        ),
      ),
      // Renderizado de la notificación flotante
      floatingActionButton:
          _showNotification
              ? FloatingNotification(
                onClose: () {
                  setState(() {
                    _showNotification = false;
                  });
                },
              )
              : null,
    );
  }
}

// Componente de la notificación flotante
class FloatingNotification extends StatelessWidget {
  final VoidCallback onClose;

  const FloatingNotification({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Material(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Stack(
            children: [
              // Mensajes de éxito en dos filas con espacio adicional
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "¡Registro actualizado correctamente!",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 5), // Espacio en blanco entre líneas
                  Text(
                    "¡La transacción se realizó exitosamente!",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              // Botón para cerrar manualmente en la esquina superior derecha
              Positioned(
                top: -5,
                right: -5,
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
