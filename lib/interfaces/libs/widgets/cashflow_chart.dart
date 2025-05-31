import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:intl/intl.dart";

import "package:app/domain/entities/modules.dart";
import "package:app/libs/extensions.dart";

/// A widget that display chart of [transactions] cash total.
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

  /// Widget to build on [transactions] empty.
  final WidgetBuilder? fallbackBuilder;

  const CashflowChart(
    this.transactions, {
    super.key,
    this.height = 400.0,
    this.header,
    this.fallbackBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final calculatedTransactions = useMemoized(() {
      return transactions.calculateCashTotal();
    }, [transactions]);

    final spots = useMemoized(() {
      if (calculatedTransactions.isEmpty) return <FlSpot>[];

      return calculatedTransactions.mapIndexed((index, transaction) {
        return FlSpot(index.toDouble(), transaction.currentCashTotal);
      }).toList();
    }, [calculatedTransactions]);

    if (transactions.isEmpty) {
      return fallbackBuilder?.call(context) ?? Text("No transactions?");
    }

    final minX = spots.first.x;
    final maxX = spots.last.x;

    final spotsY = spots.map((s) => s.y);
    final minY = spotsY.min;
    final maxY = spotsY.max;

    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16.0,
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
              maxY: maxY * 1.5,
              lineBarsData: [LineChartBarData(spots: spots, isCurved: true)],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final index = touchedSpot.x.toInt();
                      final transaction = calculatedTransactions[index];
                      final amount = transaction.amount;

                      return LineTooltipItem(
                        NumberFormat.compactCurrency(
                          symbol: "\$",
                        ).format(touchedSpot.y),
                        textTheme.bodyMedium ??
                            DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text:
                                " (${NumberFormat.compact().format(transaction.previousCashTotal)}",
                          ),
                          TextSpan(
                            text:
                                (amount.isNegative ? "" : "+") +
                                NumberFormat.compact().format(amount),
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  amount.isNegative ? colorScheme.error : null,
                            ),
                          ),
                          TextSpan(
                            text:
                                ")\n${DateFormat.yMMMMd().format(transaction.transactionDate)}",
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                rightTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxX - minX) / 3,
                    getTitlesWidget: (spotX, meta) {
                      if (spotX == meta.min || spotX == meta.max) {
                        return SizedBox.shrink();
                      }

                      final date =
                          calculatedTransactions[spotX.round()].transactionDate;

                      return SideTitleWidget(
                        meta: meta,
                        child: Text(DateFormat.yMMMMd().format(date)),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(drawVerticalLine: false),
            ),
          ),
        ),
      ],
    );
  }
}
