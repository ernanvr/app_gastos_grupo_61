import 'package:app_gastos_grupo_61/core/helpers/constants.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/blocs.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_state.dart'; // Import BudgetState
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_state.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    // Load transactions for the selected budget when the screen initializes.
    // We can access the selectedBudget directly from the BlocProvider
    // since SplashScreen ensures a budget is selected before navigating here.
    final budgetState = context.read<BudgetCubit>().state;
    if (budgetState.selectedBudget != null) {
      context.read<TransactionCubit>().loadTransactionsByBudgetId(
        budgetState.selectedBudget!.id!,
      );
    }
  }

  // Format currency using a simple method or a package like intl
  String formatCurrency(double amount) {
    // Use appropriate locale, e.g., 'en_US' for $
    final formatter = NumberFormat.simpleCurrency(locale: 'en_US');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Define colors here
    const primaryColor = Color(0xFF3F37C9);
    const backgroundColor = Color(0xFFF6FFF8);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          final budgetState = context.read<BudgetCubit>().state;
          final selectedBudgetId = budgetState.selectedBudget?.id;

          if (selectedBudgetId != null) {
            // Pass the selected budget ID to the TransactionScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TransactionScreen(budgetId: selectedBudgetId),
              ),
            );
          } else {
            // Handle case where no budget is selected (should not happen based on Splash logic)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a budget first.')),
            );
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Agregar registro',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),

      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Control de gastos',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      // Use BlocBuilder for BudgetCubit to get the selected budget
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, budgetState) {
          // Access the selected budget or handle the null case (should not happen due to Splash)
          final selectedBudget = budgetState.selectedBudget!;
          // Get the budget amount
          final budgetAmount = selectedBudget.balance;

          // Use BlocBuilder for TransactionCubit to get transactions and pie chart data
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              // Calculate total spent from transactions
              final totalSpent = transactionState.transactions
                  .where((t) => !t.isIncome) // Filter expenses
                  .fold(0.0, (sum, t) => sum + t.amount);

              // Calculate remaining

              final remaining = budgetAmount - totalSpent;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: const Color(0xFFCCDBFD),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen de gastos',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF14181B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Su actividad reciente se divide en:',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF95A1AC),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child:
                              transactionState.status ==
                                      TransactionStatus.loading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : transactionState.pieChartValues.isEmpty
                                  ? Center(
                                    child: Text(
                                      'No hay datos para el gráfico de resumen.',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: const Color(0xFF57636C),
                                      ),
                                    ),
                                  )
                                  : PieChart(
                                    PieChartData(
                                      sections:
                                          transactionState.pieChartValues
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                                final index = entry.key;
                                                final pieValue = entry.value;
                                                final totalQty =
                                                    transactionState
                                                        .pieChartValues
                                                        .fold(
                                                          0,
                                                          (sum, item) =>
                                                              sum + item.qty,
                                                        );
                                                final percentage =
                                                    totalQty > 0
                                                        ? (pieValue.qty /
                                                                totalQty) *
                                                            100
                                                        : 0.0;
                                                final color =
                                                    pieChartColors[index %
                                                        pieChartColors.length];

                                                return PieChartSectionData(
                                                  value: percentage,
                                                  color: color,
                                                  title:
                                                      totalQty > 0
                                                          ? '${percentage.toStringAsFixed(0)}%'
                                                          : '',
                                                  radius: 50,
                                                  titleStyle:
                                                      GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                  titlePositionPercentageOffset:
                                                      1.5, // Adjust title position to avoid overlapping with pie chart
                                                  badgeWidget: Text(
                                                    // Add category name as a badge
                                                    pieValue.categoryName,
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 10,
                                                      color: const Color(
                                                        0xFF14181B,
                                                      ),
                                                    ),
                                                  ),
                                                  badgePositionPercentageOffset:
                                                      1.2, // Adjust badge position
                                                );
                                              })
                                              .toList(),
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 40,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // TODO: Display budget period (e.g., Mensual) from the budget entity
                            Text(
                              'Mensual', // Placeholder
                              style: GoogleFonts.nunito(color: Colors.white),
                            ),
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
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                  ),
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
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                  ),
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Transacciones recientes:',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF14181B),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        transactionState.status == TransactionStatus.loading
                            ? const Center(child: CircularProgressIndicator())
                            : transactionState.transactions.isEmpty
                            ? Center(
                              child: Text(
                                'No hay transacciones registradas para este presupuesto.',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  color: const Color(0xFF57636C),
                                ),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: transactionState.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    transactionState.transactions[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
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
                                                  : const Color(
                                                    0xFF4895EF,
                                                  ), // Color for expense
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              transaction.isIncome
                                                  ? Icons.add
                                                  : Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transaction.description,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                transaction.categoryName,
                                                style: GoogleFonts.nunito(
                                                  color: const Color(
                                                    0xFF95A1AC,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              // Display transaction amount
                                              formatCurrency(
                                                transaction.amount,
                                              ),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    transaction.isIncome
                                                        ? Colors.green
                                                        : Colors
                                                            .redAccent, // Color based on type
                                              ),
                                            ),
                                            Text(
                                              // Display formatted date and time
                                              DateFormat(
                                                'E. d, HH:mm',
                                              ).format(transaction.date),
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
                                );
                              },
                            ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
