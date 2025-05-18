import 'package:app_gastos_grupo_61/src/presentation/widgets/success_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:go_router/go_router.dart'; // Importa go_router
import 'package:app_gastos_grupo_61/src/domain/entities/budget.dart'; // Importa la entidad Budget
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_cubit.dart'; // Importa BudgetCubit
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart'; // Import BudgetWithBalance for editing

class BudgetScreen extends StatefulWidget {
  final BudgetWithBalance? budgetToEdit; // Optional parameter for editing

  const BudgetScreen({super.key, this.budgetToEdit});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Clave global para el formulario, permite validar y guardar
  final _formKey = GlobalKey<FormState>();
  // Controladores para los campos de texto
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If budgetToEdit is provided, pre-fill the form
    if (widget.budgetToEdit != null) {
      _descriptionController.text = widget.budgetToEdit!.description;
      _amountController.text = widget.budgetToEdit!.initialAmount.toString();
      _dateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.budgetToEdit!.date);
    } else {
      // Opcional: pre-llenar la fecha actual al crear
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
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
      // Determine if we are creating or updating
      final isEditing = widget.budgetToEdit != null;

      // Create a new Budget instance or update the existing one
      final budget = Budget(
        // Use existing ID if editing, otherwise null
        id: isEditing ? widget.budgetToEdit!.id : null,
        description: _descriptionController.text,
        // Convierte el texto del monto a double
        initialAmount: double.parse(_amountController.text),
        // Parsea la fecha del texto a DateTime
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
      );

      if (isEditing) {
        // Call the cubit method to update a budget
        context.read<BudgetCubit>().editBudget(budget);
      } else {
        // Call the cubit method to add a new budget
        context.read<BudgetCubit>().addBudget(budget);
      }

      // Navigate back to the previous screen (likely HomePageScreen)
      // GoRouter pop() is the way to go back with go_router
      if (isEditing) {
        context.pop(); // Go back after editing
      } else {
        context.replaceNamed('home'); // Go to home after creating
      }

      // Get a reference to the ScaffoldMessengerState
      final messenger = ScaffoldMessenger.of(context);

      // Show the custom success notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SuccessNotificationWidget(
            title:
                isEditing
                    ? 'Presupuesto Actualizado'
                    : 'Presupuesto Creado', // Dynamic title
            message:
                isEditing
                    ? 'El presupuesto "${budget.description}" ha sido actualizado exitosamente.'
                    : 'El presupuesto "${budget.description}" ha sido creado exitosamente.', // Dynamic message
            onClose: () => messenger.hideCurrentSnackBar(),
          ),
          backgroundColor:
              Colors.transparent, // Make SnackBar background transparent
          elevation: 0, // Remove shadow
          duration: const Duration(
            seconds: 4,
          ), // How long the notification is visible
          behavior: SnackBarBehavior.floating, // Make it float above the bottom
        ),
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
                widget.budgetToEdit != null
                    ? 'Editar Presupuesto'
                    : 'Crear Presupuesto', // Dynamic title
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
                    widget.budgetToEdit != null
                        ? 'Actualizar Presupuesto'
                        : 'Guardar Presupuesto', // Dynamic button text
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
}
