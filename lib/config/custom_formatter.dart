import 'package:intl/intl.dart';

// ignore: avoid_classes_with_only_static_members
class CustomFormatter {
  static NumberFormat currencyFormat = NumberFormat.simpleCurrency(locale: 'id_ID');
  static NumberFormat numberFormat = NumberFormat.decimalPattern('id_ID');
}
