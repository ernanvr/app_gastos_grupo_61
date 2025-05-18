import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final bool isIncome;

  const Category({this.id, required this.name, required this.isIncome});

  @override
  List<Object> get props => [name, isIncome];
}
