import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities/libs/types.dart";
import "package:app/libs/decorators.dart";
import "package:app/libs/extensions.dart";

part "project_transaction.freezed.dart";
part "project_transaction.g.dart";

@freezed
@JsonSerializable()
final class ProjectTransaction extends Entity with _$ProjectTransaction {
  @override
  final int projectId;

  /// Amount of cash to deposit or withdraw.
  ///
  /// Should not be zero.
  @override
  final double amount;

  @override
  final ProjectTransactionType transactionType;

  @override
  final String description;

  @dateTimeProp
  @override
  late final DateTime transactionDate;

  /// Tags associated with the transaction.
  @ignoreJsonSerializable
  @override
  final List<ProjectTransactionTag> tags;

  /// Previous cash total before this transaction date.
  @ignoreJsonSerializable
  @override
  final double previousTotalCash;

  ProjectTransaction({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.projectId,
    required this.amount,
    required this.transactionType,
    required this.description,
    DateTime? transactionDate,
    this.tags = const <ProjectTransactionTag>[],
    this.previousTotalCash = 0.0,
  }) : assert(amount != 0, "Transaction amount should not be zero.") {
    final now = DateTime.now().toUtc().toMidnight();

    this.transactionDate = transactionDate?.toUtc().toMidnight() ?? now;
  }

  /// Sum of [previousTotalCash] and [amount].
  double get currentTotalCash => previousTotalCash + amount;

  /// Indicates if the transaction is a cash deposit.
  ///
  /// For detailed state of transaction, refer to [state].
  bool get isCashIn => amount >= 0;

  /// Determines the state of the transaction based on [amount] and
  /// [transactionType].
  ProjectTransactionState get state {
    return switch (isCashIn) {
      true => switch (transactionType) {
        ProjectTransactionType.equity => ProjectTransactionState.cashDeposit,
        ProjectTransactionType.liability =>
          ProjectTransactionState.liabilityDeposit,
        ProjectTransactionType.asset => ProjectTransactionState.assetSale,
        ProjectTransactionType.operation =>
          ProjectTransactionState.operationSale,
      },
      false => switch (transactionType) {
        ProjectTransactionType.equity => ProjectTransactionState.cashWithdrawal,
        ProjectTransactionType.liability =>
          ProjectTransactionState.liabilityRepayment,
        ProjectTransactionType.asset => ProjectTransactionState.assetPurchase,
        ProjectTransactionType.operation =>
          ProjectTransactionState.operationCost,
      },
    };
  }

  factory ProjectTransaction.fromJson(Map<String, dynamic> json) =>
      _$ProjectTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectTransactionToJson(this);
}

/// Type of transaction.
///
/// Used to determine the [ProjectTransaction.state].
enum ProjectTransactionType {
  /// Project cash deposit or withdrawal.
  equity,

  /// Project cash that needs to be repaid.
  liability,

  /// Project long-term asset purchase or sale.
  asset,

  /// Project bussiness operation costs or incomes.
  operation,
}

enum ProjectTransactionState {
  /// Deposits from owners or investors.
  cashDeposit,

  /// Fund transfer or emergency withdrawal.
  cashWithdrawal,

  /// Cash that needs to be repaid.
  liabilityDeposit,

  /// Records of liabilities repayment
  liabilityRepayment,

  /// Long-term assets, such as property, tools, etc.
  assetPurchase,

  /// Sale of project assets.
  assetSale,

  /// Product/Service costs. Such as materials, labor, and so on.
  operationCost,

  /// Revenue from Products/Services
  operationSale,
}

/// User created tag for grouping transactions.
@freezed
@JsonSerializable()
final class ProjectTransactionTag extends Entity with _$ProjectTransactionTag {
  @override
  final int projectId;

  @override
  final String name;

  @override
  final String? description;

  ProjectTransactionTag({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.projectId,
    required this.name,
    this.description,
  });

  factory ProjectTransactionTag.fromJson(Map<String, dynamic> json) =>
      _$ProjectTransactionTagFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectTransactionTagToJson(this);
}
