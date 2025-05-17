import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  // Use appropriate locale, e.g., 'en_US' for $
  final formatter = NumberFormat.simpleCurrency(locale: 'en_US');
  return formatter.format(amount);
}
