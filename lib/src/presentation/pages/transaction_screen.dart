import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import '../bloc/cubit/transaction_cubit.dart'; // Import TransactionCubit
import '../bloc/cubit/category_cubit.dart'; // Import CategoryCubit
import '../bloc/cubit/category_state.dart'; // Import CategoryState
import '../../domain/entities/category.dart'; // Import Category entity

class TransactionScreen extends StatefulWidget {
  final TransactionWithCategory? transaction;
  final int? budgetId; // Add budgetId parameter

  const TransactionScreen({super.key, this.transaction, this.budgetId});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategoryName; // Changed to store category name
  String? _selectedType; // 'Ingreso' or 'Gasto'
  final List<String> _types = ['Ingreso', 'Gasto'];
  List<Category> _availableCategories = []; // To store categories from Cubit

  @override
  void initState() {
    super.initState();
    // Load categories when the screen initializes
    context.read<CategoryCubit>().loadCategories();

    if (widget.transaction != null) {
      _nameController.text = widget.transaction!.description;
      _amountController.text = widget.transaction!.amount.toString();
      _dateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.transaction!.date);
      // When editing, pre-select category and type from the transaction
      _selectedCategoryName =
          widget.transaction!.categoryName; // Use categoryName
      _selectedType = widget.transaction!.isIncome ? 'Ingreso' : 'Gasto';
    } else {
      // Set initial date for new transactions
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
    // Ensure budgetId is available for saving
    if (widget.budgetId == null) {
      // Handle error: budgetId is required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Budget ID not provided.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Find the selected category ID based on the name
      final selectedCategory = _availableCategories.firstWhere(
        (cat) => cat.name == _selectedCategoryName,
        // orElse:
        //     () => Category(
        //       id: 0,
        //       name: _selectedCategoryName ?? 'Otros',
        //     ), // Fallback
      );

      final newTransaction = Transaction(
        // Use transaction ID if editing, otherwise null (database will assign new ID)
        id: widget.transaction?.id,
        description: _nameController.text,
        amount: double.parse(_amountController.text),
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        categoryId: selectedCategory.id!, // Use category ID
        isIncome: _selectedType == 'Ingreso',
        budgetId: widget.budgetId!, // Use the provided budgetId
      );

      // Use the Cubit to add or update the transaction
      if (widget.transaction == null) {
        // Adding a new transaction
        context.read<TransactionCubit>().insertTransaction(newTransaction);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transacción creada exitosamente!')),
        );
      } else {
        // Updating an existing transaction
        context.read<TransactionCubit>().updateTransaction(newTransaction);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transacción actualizada exitosamente!'),
          ),
        );
      }

      Navigator.pop(context); // Go back after saving
    }
  }

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
      body: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          // Optional: Show error message if save fails
          if (state.status == TransactionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error saving transaction: ${state.errorMessage}',
                ),
              ),
            );
          }
          // No need to navigate here, _saveTransaction already pops on success.
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.transaction == null
                      ? 'Crear Transacción'
                      : 'Editar Transacción',
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
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Este campo es obligatorio'
                              : null,
                ),
                _buildTextField(
                  controller: _amountController,
                  label: 'Monto',
                  hint: 'Digite una cantidad',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese un monto";
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null) return 'Monto inválido';
                    if (parsed <= 0) return 'El monto debe ser mayor a cero';
                    return null;
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
                      _dateController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(picked);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione una fecha';
                    }
                    try {
                      DateFormat('dd/MM/yyyy').parseStrict(value);
                      return null;
                    } catch (_) {
                      return 'Formato inválido';
                    }
                  },
                  readOnly: true, // Make date field readOnly
                ),
                const SizedBox(height: 10),
                // Use BlocBuilder to react to CategoryState changes
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state.status == CategoryStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == CategoryStatus.error) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Error loading categories: ${state.errorMessage}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      _availableCategories =
                          state.categories; // Update available categories

                      // Map categories to dropdown items
                      final categoryItems =
                          _availableCategories
                              .map(
                                (cat) => DropdownMenuItem<String>(
                                  value: cat.name, // Use category name as value
                                  child: Text(cat.name),
                                ),
                              )
                              .toList();

                      // Ensure the selected category is in the list if editing
                      if (widget.transaction != null &&
                          !_availableCategories.any(
                            (cat) => cat.name == _selectedCategoryName,
                          )) {
                        // If the transaction's category is not in the loaded list (e.g., deleted), handle it
                        // For now, we'll just ensure _selectedCategoryName is null if it's not valid.
                        // A better approach might be to add the transaction's category if it's missing.
                        _selectedCategoryName = null;
                      }

                      return _buildDropdown(
                        label: 'Categoría',
                        value:
                            _selectedCategoryName, // Use _selectedCategoryName
                        items: categoryItems, // Use DropdownMenuItem list
                        onChanged:
                            (val) =>
                                setState(() => _selectedCategoryName = val),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdown(
                  label: 'Tipo',
                  value: _selectedType,
                  items:
                      _types
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(), // Map strings to DropdownMenuItem
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
                    onPressed: _saveTransaction, // Call the save method
                    child: Text(
                      'Guardar',
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
    bool readOnly = false, // Added readOnly parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        readOnly:
            readOnly || onTap != null, // Use the parameter and onTap logic
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF3F37C9)),
          hintStyle: GoogleFonts.nunito(color: const Color(0xFF95A1AC)),
          filled: true,
          fillColor: const Color(0xFFCCDBFD),
          border: OutlineInputBorder(
            // Added border styles for consistency
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9)),
          ),
          enabledBorder: OutlineInputBorder(
            // Added enabled border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCCDBFD), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            // Added focused border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            // Added error border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Added focused error border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  // Updated _buildDropdown to accept List<DropdownMenuItem<String>>
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value, // Use the selected value directly
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF3F37C9)),
          filled: true,
          fillColor: const Color(0xFFCCDBFD),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9)),
          ),
          enabledBorder: OutlineInputBorder(
            // Added enabled border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCCDBFD), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            // Added focused border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F37C9), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            // Added error border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Added focused error border style
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        items: items, // Use the provided list of items
        onChanged: onChanged,
        validator:
            (val) =>
                val == null || val.isEmpty ? 'Seleccione una opción' : null,
      ),
    );
  }
}
