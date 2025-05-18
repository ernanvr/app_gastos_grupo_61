import 'package:app_gastos_grupo_61/core/helpers/constants.dart';
import 'package:app_gastos_grupo_61/core/utils/format_currency.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/delete_confirmation_message_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/tap_budget_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetDetailsWidget extends StatelessWidget {
  const BudgetDetailsWidget({
    super.key,
    required this.selectedBudget,
    required this.transactions,
    required this.onDelete,
  });

  final BudgetWithBalance selectedBudget;
  final List<Transaction> transactions;
  final void Function(BudgetWithBalance, List<Transaction>) onDelete;

  // Mostrar opciones del presupuesto
  void _showBudgetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TapBudgetOptionsWidget(
          budget: selectedBudget, // Pass the budget object from the widget
          onTapDelete:
              () => _confirmDeleteBudget(context), // Pass confirmation logic
        );
      },
    );
  }

  // Confirmar antes de eliminar un presupuesto
  void _confirmDeleteBudget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationMessageWidget(
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            Navigator.pop(context); // Close the confirmation dialog
            onDelete(
              selectedBudget,
              transactions,
            ); // Call the onDelete callback provided by the parent
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = transactions
        .where((t) => !t.isIncome) // Filter expenses
        .fold(0.0, (sum, t) => sum + t.amount);

    final budgetAmount = selectedBudget.balance;
    final remaining = budgetAmount - totalSpent;
    return GestureDetector(
      onTap: () => _showBudgetOptions(context),
      child: Container(
        color: primaryColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Display selected budget name
              selectedBudget.description,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  // Display initial budget amount
                  formatCurrency(budgetAmount),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // TODO: Display budget period (e.g., Mensual) from the budget entity
                // Text(
                //   'Mensual', // Placeholder
                //   style: GoogleFonts.nunito(color: Colors.white),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Restante: ',
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                    Text(
                      // Display remaining amount
                      formatCurrency(remaining),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Total gastado: ',
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                    Text(
                      // Display total spent amount
                      formatCurrency(totalSpent),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
