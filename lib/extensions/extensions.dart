
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension CustomDouble on double {
  String formattedAmount({bool? withSymbol}) {
    withSymbol = withSymbol ?? false;
    var summa = NumberFormat("#,##0.##").format(this).replaceAll(",", " ");
    if (withSymbol) {
      summa = summa + (" so'm");
    }
    return summa;
  }
}

extension CustomStringAmount on String {
  String formattedAmount({bool? withSymbol}) {
    withSymbol = withSymbol ?? false;
    var summa = NumberFormat("#,##0.##").format(this).replaceAll(",", " ");
    if (withSymbol) {
      summa = summa + (" so'm");
    }
    return summa;
  }
}

extension CustomStringToDouble on String {
  double parseToDouble() {
    var value = replaceAll(" ", "");
    var item = double.parse(value.isEmpty ? "0" : value);

    return item;
  }
}

extension NumDurationExtensions on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get ms => (this * 1000).microseconds;
  Duration get milliseconds => (this * 1000).microseconds;
  Duration get seconds => (this * 1000 * 1000).microseconds;
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}


