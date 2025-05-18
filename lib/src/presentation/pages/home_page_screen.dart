import 'package:app_gastos_grupo_61/core/helpers/constants.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/blocs.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_state.dart'; // Import BudgetState
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_state.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/transaction_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/budget_details_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/success_notification_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/transaction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

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

          // Use BlocBuilder for TransactionCubit to get transactions and pie chart data
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              final transactions = transactionState.transactions;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: const Color(0xFFCCDBFD),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Resumen de gastos',
                        //   style: GoogleFonts.poppins(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: const Color(0xFF14181B),
                        //   ),
                        // ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   'Su actividad reciente se divide en:',
                        //   style: GoogleFonts.nunito(
                        //     color: const Color(0xFF95A1AC),
                        //     fontSize: 14,
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
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
                                                        color: Colors.black,
                                                      ),
                                                  titlePositionPercentageOffset:
                                                      1.55, // Adjust title position to avoid overlapping with pie chart
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
                  BudgetDetailsWidget(
                    selectedBudget: selectedBudget,
                    transactions: transactions,
                    onDelete: (b, ts) {
                      context.read<TransactionCubit>().deleteTransactions(ts);
                      context.read<BudgetCubit>().deleteBudget(b);
                      // Get a reference to the ScaffoldMessengerState
                      final messenger = ScaffoldMessenger.of(context);
                      // Show success notification after calling delete
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: SuccessNotificationWidget(
                            title: 'Presupuesto Eliminado',
                            message:
                                'El presupuesto "${b.description}" ha sido eliminada exitosamente.',
                            onClose: () => messenger.hideCurrentSnackBar(),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          duration: const Duration(seconds: 4),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      // Navigate back to SplashScreen after budget is deleted
                      // Use addPostFrameCallback to navigate after the current frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/');
                      });
                    },
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
                                return TransactionCardWidget(
                                  transaction: transaction,
                                  onDelete: (t) {
                                    context
                                        .read<TransactionCubit>()
                                        .deleteTransaction(t);
                                    // Get a reference to the ScaffoldMessengerState
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    // Show success notification after calling delete
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: SuccessNotificationWidget(
                                          title: 'Registro Eliminado',
                                          message:
                                              'La transacción "${t.description}" ha sido eliminada exitosamente.',
                                          onClose:
                                              () =>
                                                  messenger
                                                      .hideCurrentSnackBar(),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        duration: const Duration(seconds: 4),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
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
