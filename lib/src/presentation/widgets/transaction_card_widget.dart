import 'package:app_gastos_grupo_61/core/utils/format_currency.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionCardWidget extends StatelessWidget {
  final TransactionWithCategory transaction;
  final void Function(Transaction) onDelete;

  const TransactionCardWidget({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  // Mostrar opciones de la transacción
  void _showTransactionOptions(BuildContext context) {
    final titulo = transaction.description;

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
                  // Navigate to the update-transaction route, passing the transaction object
                  Navigator.pop(context); // Close the AlertDialog
                  GoRouter.of(context).pushNamed(
                    'update-transaction',
                    extra: transaction, // Pass the current transaction object
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar Registro'),
                onTap: () {
                  //Do something else?
                  Navigator.pop(context);
                  _confirmDelete(context);
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
  void _confirmDelete(BuildContext context) {
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
                  onDelete(transaction);
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTransactionOptions(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Card(
                color:
                    transaction.isIncome
                        ? Colors
                            .green // Color for income
                        : const Color(0xFF4895EF), // Color for expense
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    transaction.isIncome ? Icons.add : Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      transaction.categoryName,
                      style: GoogleFonts.nunito(color: const Color(0xFF95A1AC)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // Display transaction amount
                    formatCurrency(transaction.amount),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color:
                          transaction.isIncome
                              ? Colors.green
                              : Colors.redAccent, // Color based on type
                    ),
                  ),
                  Text(
                    // Display formatted date and time
                    DateFormat('E. d, HH:mm').format(transaction.date),
                    style: GoogleFonts.nunito(
                      color: const Color(0xFF95A1AC),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
