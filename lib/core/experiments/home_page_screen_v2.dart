import 'package:app_gastos_grupo_61/core/helpers/app_theme.dart';
import 'package:app_gastos_grupo_61/src/data/models/transaction_with_category_model.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/blocs.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_state.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_state.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    final budgetState = context.read<BudgetCubit>().state;
    if (budgetState.selectedBudget != null) {
      context.read<TransactionCubit>().loadTransactionsByBudgetId(
        budgetState.selectedBudget!.id!,
      );
    }
  }

  String formatCurrency(double amount) =>
      NumberFormat.simpleCurrency(locale: 'en_US').format(amount);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F37C9);
    const backgroundColor = Color(0xFFF6FFF8);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: _fab(primaryColor),
      appBar: _appBar(primaryColor),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, budgetState) {
          final selectedBudget = budgetState.selectedBudget!;
          final budgetAmount = selectedBudget.balance;

          return BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, txState) {
              final totalSpent = txState.transactions
                  .where((t) => !t.isIncome)
                  .fold(0.0, (sum, t) => sum + t.amount);
              final remaining = budgetAmount - totalSpent;

              return CustomScrollView(
                slivers: [
                  // Resumen de gastos
                  SliverToBoxAdapter(child: _buildResumenDeGastos(txState)),

                  // Presupuesto fijo
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PresupuestoHeaderDelegate(
                      minExtent: 150,
                      maxExtent: 150,
                      child: _buildPresupuestoCard(
                        primaryColor,
                        selectedBudget.description,
                        budgetAmount,
                        remaining,
                        totalSpent,
                      ),
                    ),
                  ),

                  // Título lista scrolleable
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      child: Text(
                        'Transacciones recientes:',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF14181B),
                        ),
                      ),
                    ),
                  ),

                  // Lista de transacciones
                  if (txState.status == TransactionStatus.loading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (txState.transactions.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No hay transacciones registradas para este presupuesto.',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: const Color(0xFF57636C),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _transactionTile(
                          txState.transactions[index]
                              as TransactionWithCategoryModel,
                        ),
                        childCount: txState.transactions.length,
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

  // Widgets auxiliares

  PreferredSizeWidget _appBar(Color primaryColor) => AppBar(
    backgroundColor: primaryColor,
    title: Text(
      'Control de gastos',
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    automaticallyImplyLeading: false,
  );

  Widget _fab(Color primaryColor) => FloatingActionButton.extended(
    backgroundColor: primaryColor,
    onPressed: () {
      final budgetId = context.read<BudgetCubit>().state.selectedBudget?.id;
      if (budgetId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionScreen(budgetId: budgetId),
          ),
        );
      } else {
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
  );

  // Resumen de gastos (sin cambios de lógica)
  Widget _buildResumenDeGastos(TransactionState txState) {
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
    return Container(
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
                txState.status == TransactionStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : txState.expensesPieChartValues.isEmpty
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
                            txState.expensesPieChartValues.asMap().entries.map((
                              entry,
                            ) {
                              final i = entry.key;
                              final pieValue = entry.value;
                              final totalQty = txState.expensesPieChartValues
                                  .fold(0, (s, it) => s + it.spend);
                              final percentage =
                                  totalQty > 0
                                      ? pieValue.spend / totalQty * 100
                                      : 0.0;
                              final color =
                                  themePieChartColors[i %
                                      themePieChartColors.length];

                              return PieChartSectionData(
                                value: percentage,
                                color: color,
                                title:
                                    totalQty > 0
                                        ? '${percentage.toStringAsFixed(0)}%'
                                        : '',
                                radius: 50,
                                titleStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                titlePositionPercentageOffset: 1.5,
                                badgeWidget: Text(
                                  pieValue.categoryName,
                                  style: GoogleFonts.nunito(
                                    fontSize: 10,
                                    color: const Color(0xFF14181B),
                                  ),
                                ),
                                badgePositionPercentageOffset: 1.2,
                              );
                            }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de presupuesto (sin cambios de estilo) se queda fija arriba
  Widget _buildPresupuestoCard(
    Color primary,
    String description,
    double budgetAmount,
    double remaining,
    double totalSpent,
  ) {
    return Container(
      color: primary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
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
                formatCurrency(budgetAmount),
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text('Mensual', style: GoogleFonts.nunito(color: Colors.white)),
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
    );
  }

  // Tile de transacción (reutilizado)
  Widget _transactionTile(TransactionWithCategoryModel t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
              color: t.isIncome ? Colors.green : const Color(0xFF4895EF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  t.isIncome ? Icons.add : Icons.remove,
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
                    t.description,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    t.categoryName,
                    style: GoogleFonts.nunito(color: const Color(0xFF95A1AC)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(t.amount),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: t.isIncome ? Colors.green : Colors.redAccent,
                  ),
                ),
                Text(
                  DateFormat('E. d, HH:mm').format(t.date),
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
  }
}

// Delegate para header fijo
class _PresupuestoHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;
  _PresupuestoHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant _PresupuestoHeaderDelegate old) =>
      minExtent != old.minExtent ||
      maxExtent != old.maxExtent ||
      child != old.child;
}
