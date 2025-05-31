import "package:collection/collection.dart";

import "package:app/domain/entities/modules.dart";

extension ProjectTransactionListX on List<ProjectTransaction> {
  /// Return a new list with calculated cash total.
  ///
  /// Make sure the first item already fecthed the
  /// [ProjectTransaction.previousCashTotal]
  List<ProjectTransaction> calculateCashTotal() {
    return mapIndexed((index, transaction) {
      if (index == 0) return transaction;

      return transaction.copyWith(
        previousCashTotal: this[index - 1].currentCashTotal,
      );
    }).toList();
  }
}
