import "package:collection/collection.dart";

import "package:app/domain/entities/modules.dart";

extension ProjectTransactionListX on List<ProjectTransaction> {
  /// Return a new list with calculated cash total.
  ///
  /// Make sure the first item already fecthed the
  /// [ProjectTransaction.previousTotalCash]
  List<ProjectTransaction> calculateCashTotal() {
    if (isEmpty) return <ProjectTransaction>[];

    double previousTotalCashTmp = 0.0;

    return mapIndexed((index, transaction) {
      if (index == 0) {
        previousTotalCashTmp = transaction.currentTotalCash;

        return transaction;
      }

      final newTransaction = transaction.copyWith(
        previousTotalCash: previousTotalCashTmp,
      );

      previousTotalCashTmp = newTransaction.currentTotalCash;

      return newTransaction;
    }).toList();
  }
}
