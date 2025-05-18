import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';

enum TransactionStatus { initial, loading, loaded, error }

// [{ category: '', qtyTransactions: 0 }]

class TransactionState {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.expensesPieChartValues = const [],
    this.incomesPieChartValues = const [],
  });

  final TransactionStatus status;
  final List<TransactionWithCategory> transactions;
  final String? errorMessage;
  final List<PieChartValue> expensesPieChartValues;
  final List<PieChartValue> incomesPieChartValues;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionWithCategory>? transactions,
    String? errorMessage,
    List<PieChartValue>? expensesPieChartValues,
    List<PieChartValue>? incomesPieChartValues,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      expensesPieChartValues: expensesPieChartValues ?? this.expensesPieChartValues,
      incomesPieChartValues: incomesPieChartValues ?? this.incomesPieChartValues,
    );
  }
}
