import 'package:flutter/material.dart';

class AHomePage extends StatefulWidget {
  const AHomePage({Key? key}) : super(key: key);

  @override
  State<AHomePage> createState() => _AHomePageState();
}

class _AHomePageState extends State<AHomePage> {
  // Lista dinámica de transacciones
  List<Map<String, String>> transacciones = [
    {'titulo': 'Transacción 1', 'subtitulo': 'Gasto', 'monto': '\$50.00'},
    {'titulo': 'Transacción 2', 'subtitulo': 'Gasto', 'monto': '\$75.00'},
    {'titulo': 'Transacción 3', 'subtitulo': 'Gasto', 'monto': '\$100.00'},
  ];

  // Mostrar opciones de la transacción
  void _showTransactionOptions(BuildContext context, int index) {
    final transaccion = transacciones[index];
    final titulo = transaccion['titulo']!;
    final monto = transaccion['monto']!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Opciones para "$titulo"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar Registro'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí podrías navegar a una página de edición
                  print('Editar: $titulo - $monto');
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar Registro'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmarEliminacion(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Confirmar antes de eliminar
  void _confirmarEliminacion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar esta transacción?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    transacciones.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  // Crear cada tarjeta de transacción
  Widget _buildTransactionItem(
    BuildContext context,
    int index,
    Map<String, String> transaccion,
  ) {
    return GestureDetector(
      onTap: () => _showTransactionOptions(context, index),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(
            Icons.monetization_on_rounded,
            color: Colors.deepPurple,
          ),
          title: Text(transaccion['titulo']!),
          subtitle: Text(transaccion['subtitulo']!),
          trailing: Text(transaccion['monto']!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Control de gastos')),
      body: ListView.builder(
        itemCount: transacciones.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Transacciones recientes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          final trans = transacciones[index - 1];
          return _buildTransactionItem(context, index - 1, trans);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aquí podrías abrir un formulario para agregar una nueva transacción
          print('Agregar nuevo registro');
        },
        label: Text('+ Agregar registro'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
