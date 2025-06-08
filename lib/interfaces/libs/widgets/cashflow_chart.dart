import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:intl/intl.dart";

import "package:app/domain/entities/modules.dart";
import "package:app/libs/extensions.dart";

typedef CashflowChartXAxisLabelBuilder =
    String Function(ProjectTransaction transaction);

/// A widget that display chart of [transactions] cash total.
///
/// So the chart Y axis will be [ProjectTransaction.currentTotalCash].
///
/// For the X axis, it will use formatted [ProjectTransaction.transactionDate]
/// by default, but you can provide [xAxisLabelBuilder] to customize it. Just
/// make sure to sort [transactions] to fit the X axis label condition.
class CashflowChart extends HookWidget {
  final List<ProjectTransaction> transactions;

  /// Widget height.
  ///
  /// Should be fixed height or the chart can't figure its constraint.
  final double height;

  /// Widget to build before the chart.
  ///
  /// Typically a [Text] widget.
  final Widget? header;

  /// Custom label on the X axis of the chart.
  ///
  /// Default to formatted [ProjectTransaction.transactionDate].
  ///
  /// If you provide this custom builder, please don't forget to sort
  /// [transactions] to fit the condition.
  final CashflowChartXAxisLabelBuilder? xAxisLabelBuilder;

  /// Widget to build on [transactions] empty.
  final WidgetBuilder? fallbackBuilder;

  const CashflowChart(
    this.transactions, {
    super.key,
    this.height = 300.0,
    this.header,
    this.xAxisLabelBuilder,
    this.fallbackBuilder,
  });

  AxisTitles _getXAxisTitles(
    double minX,
    double maxX, {
    List<ProjectTransaction> transactions = const <ProjectTransaction>[],
  }) {
    final interval = (maxX - minX) / 4;

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40.0,
        interval: interval == 0 ? null : interval,
        getTitlesWidget: (spotX, meta) {
          if (meta.min == spotX || meta.max == spotX) {
            return const SizedBox.shrink();
          }

          final transaction = transactions[spotX.round()];

          return SideTitleWidget(
            meta: meta,
            child: Text(
              xAxisLabelBuilder?.call(transaction) ??
                  DateFormat.yMMMd().format(transaction.transactionDate),
            ),
          );
        },
      ),
    );
  }

  AxisTitles _getYAxisTitles(double minY, double maxY) {
    final interval = (maxY - minY) / 4;

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 60.0,
        interval: interval == 0 ? null : interval,
      ),
    );
  }

  FlBorderData _getBorderData(BuildContext context) {
    return FlBorderData(
      show: true,
      border: Border.fromBorderSide(
        BorderSide(color: context.colorScheme.outline),
      ),
    );
  }

  LineTouchTooltipData _getTouchTooltipData(
    BuildContext context,
    List<ProjectTransaction> transactions,
  ) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LineTouchTooltipData(
      getTooltipColor: (_) => colorScheme.surfaceContainer,
      tooltipBorder: BorderSide(color: colorScheme.outline),
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((touchedSpot) {
          final index = touchedSpot.x.toInt();
          final transaction = transactions[index];
          final amount = transaction.amount;

          final textStyle = (textTheme.bodyMedium ??
                  DefaultTextStyle.of(context).style)
              .copyWith(color: colorScheme.onSurface);

          final isPreviousCashIsZero = transaction.previousTotalCash == 0;

          return LineTooltipItem(
            NumberFormat.compactCurrency(symbol: "\$").format(touchedSpot.y),
            textStyle,
            children: [
              if (!isPreviousCashIsZero) ...[
                TextSpan(
                  text:
                      " (${NumberFormat.compact().format(transaction.previousTotalCash)} ",
                ),
                TextSpan(
                  text:
                      (amount.isNegative ? "" : "+") +
                      NumberFormat.compact().format(amount),
                  style: textStyle.copyWith(
                    color:
                        amount.isNegative
                            ? colorScheme.error
                            : colorScheme.primary,
                  ),
                ),
                TextSpan(text: ")"),
              ],
              TextSpan(text: "\n"),
              TextSpan(
                text: DateFormat.yMMMMd().format(transaction.transactionDate),
              ),
            ],
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ProjectTransaction> calculatedTransactions = useMemoized(() {
      return transactions.calculateCashTotal();
    }, [transactions]);

    final List<FlSpot> spots = useMemoized(() {
      if (calculatedTransactions.isEmpty) return [];

      return calculatedTransactions.mapIndexed((index, transaction) {
        return FlSpot(index.toDouble(), transaction.currentTotalCash);
      }).toList();
    }, [calculatedTransactions]);

    if (transactions.isEmpty) {
      return fallbackBuilder?.call(context) ?? Text("No transactions?");
    }

    final minX = spots.first.x;
    final maxX = spots.last.x;

    final spotYValues = spots.map((s) => s.y);
    final minY = spotYValues.min;
    final maxY = spotYValues.max * 1.5;

    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final lineGradient = LinearGradient(
      colors: [colorScheme.primary, colorScheme.secondary],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        DefaultTextStyle(
          style: textTheme.bodyLarge ?? DefaultTextStyle.of(context).style,
          child: header ?? SizedBox.shrink(),
        ),
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  gradient: lineGradient,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors:
                          lineGradient.colors
                              .map((color) => color.withValues(alpha: 0.3))
                              .toList(),
                    ),
                  ),
                  isCurved: true,
                  spots: spots,
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: _getTouchTooltipData(
                  context,
                  calculatedTransactions,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                bottomTitles: _getXAxisTitles(
                  minX,
                  maxX,
                  transactions: calculatedTransactions,
                ),
                leftTitles: _getYAxisTitles(minY, maxY),
                rightTitles: _getYAxisTitles(minY, maxY),
              ),
              borderData: _getBorderData(context),
            ),
          ),
        ),
      ],
    );
  }
}
