import 'package:equatable/equatable.dart';

// Nombre en inglés y en singular
class Transaction extends Equatable {
  const Transaction({
    this.id,
    required this.categoryId,
    required this.budgetId,
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  // Propiedades
  final int? id;
  final int categoryId;
  final int budgetId;
  final String description;
  final double amount;
  final DateTime date;
  final bool isIncome;

  // Equatable override para comparación
  @override
  List<Object?> get props => [
    id,
    categoryId,
    description,
    amount,
    date,
    isIncome,
  ];
}
