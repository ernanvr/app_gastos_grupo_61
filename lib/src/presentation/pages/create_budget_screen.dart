import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:go_router/go_router.dart'; // Importa go_router
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart'; // Importa la entidad Budget
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_cubit.dart'; // Importa BudgetCubit

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  // Clave global para el formulario, permite validar y guardar
  final _formKey = GlobalKey<FormState>();
  // Controladores para los campos de texto
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Opcional: pre-llenar la fecha actual al crear
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    // Desecha los controladores cuando el widget se elimine
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Método para guardar el presupuesto
  void _saveBudget() {
    // Valida el formulario. Si es válido, procede.
    if (_formKey.currentState!.validate()) {
      // Crea una nueva instancia de Budget con los datos del formulario
      final newBudget = Budget(
        // El ID es null porque la base de datos lo generará al insertar
        id: null,
        description: _descriptionController.text,
        // Convierte el texto del monto a double
        initialAmount: double.parse(_amountController.text),
        // Parsea la fecha del texto a DateTime
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
      );

      // Accede al BudgetCubit y llama al método para agregar un presupuesto
      // Usamos context.read para obtener el Cubit ya proporcionado en el árbol de widgets
      context.read<BudgetCubit>().addBudget(newBudget);

      // Navega a Home
      // GoRouter pop() es la forma de regresar con go_router
      context.replaceNamed('home');

      // Opcional: Mostrar un mensaje de éxito al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presupuesto creado exitosamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colores para consistencia con otras pantallas
    const primaryColor = Color(0xFF3F37C9);
    const backgroundColor = Color(0xFFF6FFF8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(), // Usa context.pop para regresar
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asigna la clave del formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear Presupuesto',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de texto para la descripción del presupuesto
              _buildTextField(
                controller: _descriptionController,
                label: 'Descripción del Presupuesto',
                hint: 'Ej: Presupuesto mensual de casa',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Este campo es obligatorio'
                            : null,
              ),
              // Campo de texto para el monto inicial
              _buildTextField(
                controller: _amountController,
                label: 'Monto Inicial',
                hint: 'Ej: 1000.00',
                keyboardType: TextInputType.number, // Teclado numérico
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un monto';
                  final parsed = double.tryParse(value);
                  // Valida que sea un número válido y mayor a 0
                  if (parsed == null) return 'Monto inválido';
                  if (parsed <= 0) return 'El monto debe ser mayor a cero';
                  return null;
                },
              ),
              // Campo de texto para la fecha (selector de fecha)
              _buildTextField(
                controller: _dateController,
                label: 'Fecha de Inicio',
                hint: 'Seleccione una fecha',
                onTap: () async {
                  // Cierra el teclado al abrir el selector de fecha
                  FocusScope.of(context).requestFocus(FocusNode());
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), // Rango de fechas
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    // Formatea la fecha seleccionada y la muestra en el campo de texto
                    _dateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(picked);
                  }
                },
                readOnly:
                    true, // Hace que el campo sea solo de lectura para obligar a usar el selector
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione una fecha';
                  }
                  try {
                    // Intenta parsear la fecha para validar el formato
                    DateFormat('dd/MM/yyyy').parseStrict(value);
                    return null;
                  } catch (_) {
                    return 'Formato de fecha inválido';
                  }
                },
              ),
              const SizedBox(height: 20),
              // Botón para guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  onPressed: _saveBudget, // Llama al método para guardar
                  child: Text(
                    'Guardar Presupuesto',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para crear los campos de texto (reutilizado de TransactionScreen)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false, // Añadido para campos de solo lectura como la fecha
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        readOnly: readOnly, // Usa el parámetro readOnly
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF3F37C9)),
          hintStyle: GoogleFonts.nunito(color: const Color(0xFF95A1AC)),
          filled: true,
          fillColor: const Color(0xFFCCDBFD),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9)),
          ),
          enabledBorder: OutlineInputBorder(
            // Estilo del borde cuando está habilitado
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCCDBFD), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            // Estilo del borde cuando tiene el foco
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            // Estilo del borde cuando hay error
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Estilo del borde cuando hay error y tiene el foco
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  // No necesitamos _buildDropdown ni _getCategoryId en esta pantalla
}
