import 'package:app_gastos_grupo_61/core/utils/format_currency.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/delete_confirmation_message_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/tap_transaction_options_widget.dart'; // Import the new widget
import 'package:flutter/material.dart';
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
    // Replace showDialog with showModalBottomSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the bottom sheet to take full height if needed
      builder: (context) {
        // Return the TapTransactionOptionsWidget
        return TapTransactionOptionsWidget(
          transaction: transaction, // Pass the transaction object
          onTapDelete:
              () => _confirmDelete(
                context,
              ), // Pass a function that calls _confirmDelete
        );
      },
    );
  }

  // Confirmar antes de eliminar - This method remains the same
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationMessageWidget(
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            Navigator.pop(context); // Close the confirmation dialog
            onDelete(
              transaction,
            ); // Call the actual onDelete callback from the parent
          },
        );
      },
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
