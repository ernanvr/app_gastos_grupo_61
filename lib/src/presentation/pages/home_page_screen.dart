import 'package:app_gastos_grupo_61/core/helpers/app_theme.dart';
import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/blocs.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_state.dart'; // Import BudgetState
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_state.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/transaction_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/budget_details_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/piechart_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/success_notification_widget.dart';
import 'package:app_gastos_grupo_61/src/presentation/widgets/transaction_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TransactionType _selectedTransactionType =
      TransactionType.expense; // Add state variable

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
    // Access the current theme
    final theme = AppTheme.of(context);

    // Define a list of theme colors to use for the pie chart
    final List<Color> themePieChartColors = [
      theme.primary,
      theme.accent1,
      theme.tertiary,
      theme.alternate,
      theme.secondary,
      theme.accent2,
      theme.accent3,
      theme.accent4,
      // Add more colors from your theme as needed to ensure enough variety
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          final budgetState = context.watch<BudgetCubit>().state;
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
            // After returning from TransactionScreen, reload transactions
            context.read<TransactionCubit>().loadTransactionsByBudgetId(
              selectedBudgetId,
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
          // Handle the case where no budget is selected yet
          if (budgetState.selectedBudget == null) {
            return const Center(
              child: CircularProgressIndicator(), // Or a message
            );
          }

          // Access the selected budget
          final selectedBudget = budgetState.selectedBudget!;

          // Use BlocBuilder for TransactionCubit to get transactions and pie chart data
          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, transactionState) {
              final transactions = transactionState.transactions;

              // Determine which data to display based on the selected type
              final List<PieChartValue> currentPieChartValues =
                  _selectedTransactionType == TransactionType.expense
                      ? transactionState.expensesPieChartValues
                      : transactionState.incomesPieChartValues;

              // Prepare data for AppPieChart
              List<double> pieValues =
                  currentPieChartValues.map((e) => e.spend.toDouble()).toList();

              // Use the theme colors for the pie chart
              final List<Color> pieColors =
                  currentPieChartValues.asMap().entries.map((entry) {
                    final index = entry.key;
                    return themePieChartColors[index %
                        themePieChartColors.length];
                  }).toList();

              // Calculate the total spend to normalize the radius
              final double totalSpend = pieValues.fold(
                0.0,
                (sum, item) => sum + item,
              );

              // --- Start: Adjust pie chart percentages to sum to 100 ---
              // This block calculates raw percentages, rounds them, identifies
              // any difference from 100% due to rounding, and adjusts one slice's
              // rounded percentage to make the total sum exactly 100.
              // The pieValues list is then updated to contain these adjusted
              // rounded percentages, which the chart will use for proportions
              // and labels.
              if (totalSpend > 0) {
                // 1. Calculate raw percentages based on original values
                final List<double> rawPercentages =
                    pieValues
                        .map((value) => (value / totalSpend) * 100.0)
                        .toList();

                // 2. Round percentages to the nearest integer (assuming 0 decimal places for display)
                final List<int> roundedPercentages =
                    rawPercentages
                        .map((percentage) => percentage.round())
                        .toList();

                // 3. Calculate the current sum of rounded percentages
                final int sumRounded = roundedPercentages.fold(
                  0,
                  (sum, percentage) => sum + percentage,
                );

                // 4. Calculate the difference from 100
                final int difference = 100 - sumRounded;

                // 5. If there is a difference, apply it to the slice
                //    with the largest raw percentage to minimize visual distortion.
                if (difference != 0) {
                  int maxIndex = 0;
                  double maxRawPercentage =
                      -1.0; // Find index of largest raw percentage
                  for (int i = 0; i < rawPercentages.length; i++) {
                    if (rawPercentages[i] > maxRawPercentage) {
                      maxRawPercentage = rawPercentages[i];
                      maxIndex = i;
                    }
                    // Note: Handling ties by picking the first occurrence is implicit here.
                  }
                  // Adjust the rounded percentage at the max index
                  roundedPercentages[maxIndex] += difference;
                }

                // 6. Update pieValues to be the adjusted rounded percentages.
                //    The chart will now use these adjusted values for proportions and labels.
                //    Convert int percentages back to double as required by CustomPieChartData.
                pieValues =
                    roundedPercentages.map((p) => p.toDouble()).toList();
              }
              // --- End: Adjust pie chart percentages ---
              //Dynamic radius
              final List<double> pieRadius =
                  currentPieChartValues.map((e) {
                    // Define a minimum and maximum radius
                    const double minRadius = 30.0;
                    const double maxRadius = 80.0;

                    // Calculate a proportional radius. Avoid division by zero if totalSpend is 0.
                    final double normalizedSpend =
                        totalSpend > 0 ? e.spend / totalSpend : 0.0;
                    final double dynamicRadius =
                        minRadius + (maxRadius - minRadius) * normalizedSpend;

                    return dynamicRadius;
                  }).toList();

              final List<LegendEntry> legendEntries =
                  currentPieChartValues.asMap().entries.map((entry) {
                    final index = entry.key;
                    final pieValue = entry.value;
                    final color =
                        themePieChartColors[index % themePieChartColors.length];
                    return LegendEntry(
                      color,
                      pieValue.categoryName,
                    ); // Use categoryName for legend
                  }).toList();

              final customPieChartData = CustomPieChartData(
                values: pieValues,
                colors: pieColors,
                radius: pieRadius,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: const Color(0xFFCCDBFD),
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      bottom: 16,
                      top: 4,
                      right: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                // Add padding for the dropdown
                                padding: const EdgeInsets.only(bottom: 8),
                                child: DropdownButton<TransactionType>(
                                  value: _selectedTransactionType,
                                  items: const [
                                    DropdownMenuItem(
                                      value: TransactionType.expense,
                                      child: Text('Gastos'),
                                    ),
                                    DropdownMenuItem(
                                      value: TransactionType.income,
                                      child: Text('Ingresos'),
                                    ),
                                  ],
                                  onChanged: (TransactionType? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedTransactionType = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
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
                              const SizedBox(
                                width: 16.0,
                              ), // Add horizontal spacing
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                ), // Add padding to the left
                                child: SizedBox(
                                  width: 150,
                                  height: 175,
                                  child:
                                      transactionState.status ==
                                              TransactionStatus.loading
                                          ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                          : transactionState
                                              .expensesPieChartValues
                                              .isEmpty
                                          ? Center(
                                            child: Text(
                                              'No hay datos para el gráfico de resumen.',
                                              style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                color: const Color(0xFF57636C),
                                              ),
                                            ),
                                          )
                                          : AppPieChart(
                                            // Use AppPieChart here
                                            data: customPieChartData,
                                            donutHoleRadius:
                                                20, // Adjust as needed
                                            sectionLabelType:
                                                PieChartSectionLabelType
                                                    .percent, // Or .value
                                            sectionLabelStyle:
                                                GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 36.0), // Add horizontal spacing
                        Expanded(
                          child: AppChartLegendWidget(
                            // Add the legend widget
                            entries:
                                legendEntries, // <-- Here is where you place it
                            textStyle: GoogleFonts.nunito(
                              fontSize: 14,
                              color: const Color(0xFF14181B),
                            ),
                            indicatorSize: 12,
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
