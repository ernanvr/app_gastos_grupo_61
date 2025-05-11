import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/transaction.dart';


class UpdateTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const UpdateTransactionScreen({super.key, this.transaction});

  @override
  State<UpdateTransactionScreen> createState() => _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;
  final List<String> _categories = ['Comida', 'Transporte', 'Salario', 'Otros'];
  final List<String> _types = ['Ingreso', 'Gasto'];

 /* Para cuando este listo el BLOC:
  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _nameController.text = widget.transaction!.description;
      _amountController.text = widget.transaction!.amount.toString();
      _dateController.text = DateFormat('dd/MM/yyyy').format(widget.transaction!.date);
      _selectedCategory = widget.transaction!.category;
      _selectedType = widget.transaction!.isIncome ? 'Ingreso' : 'Gasto';
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        id: widget.transaction?.id ?? 0,
        description: _nameController.text,
        amount: double.parse(_amountController.text),
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        category: _selectedCategory!,
        isIncome: _selectedType == 'Ingreso',
        budgetId: 1, // cambiar si manejas múltiples presupuestos
      );

      // Aquí se debería llamar a tu caso de uso: InsertTransactionUseCase o UpdateTransactionUseCase
      print("Transacción guardada: $newTransaction");

      Navigator.pop(context, newTransaction);
    }
  }
*/



  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F37C9);
    const backgroundColor = Color(0xFFF6FFF8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.transaction == null ? 'Crear Transacción' : 'Editar Transacción',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF14181B),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: 'Nombre de la Transacción',
                hint: 'Escriba una descripción',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              _buildTextField(
                controller: _amountController,
                label: 'Monto',
                hint: 'Digite una cantidad',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un monto';
                  final parsed = double.tryParse(value);
                  return parsed == null ? 'Monto inválido' : null;
                },
              ),
              _buildTextField(
                controller: _dateController,
                label: 'Fecha',
                hint: 'Seleccione una fecha',
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Seleccione una fecha';
                  try {
                    DateFormat('dd/MM/yyyy').parseStrict(value);
                    return null;
                  } catch (_) {
                    return 'Formato inválido';
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                label: 'Categoría',
                value: _selectedCategory,
                items: _categories,
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                label: 'Tipo',
                value: _selectedType,
                items: _types,
                onChanged: (val) => setState(() => _selectedType = val),
              ),
              const SizedBox(height: 20),
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
                  onPressed: () {},//_saveTransaction,
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        readOnly: onTap != null,
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
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: const Color(0xFF3F37C9)),
        filled: true,
        fillColor: const Color(0xFFCCDBFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3F37C9)),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null || val.isEmpty ? 'Seleccione una opción' : null,
    );
  }
}
