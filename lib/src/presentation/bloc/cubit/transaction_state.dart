import 'package:app_gastos_grupo_61/core/helpers/classes.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';

enum TransactionStatus { initial, loading, loaded, error }

// [{ category: '', qtyTransactions: 0 }]

class TransactionState {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.pieChartValues = const [],
  });

  final TransactionStatus status;
  final List<TransactionWithCategory> transactions;
  final String? errorMessage;
  final List<PieChartValue> pieChartValues;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionWithCategory>? transactions,
    String? errorMessage,
    List<PieChartValue>? pieChartValues,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      pieChartValues: pieChartValues ?? this.pieChartValues,
    );
  }
}
