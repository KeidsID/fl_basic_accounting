import "package:fl_utilities/fl_utilities.dart";
import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "package:app/libs/enums.dart";
import "package:app/libs/types.dart";
import "package:intl/intl.dart";

/// [ProjectTransactionsFilterModalSheet] initial and return values.
typedef ProjectTransactionsFilterModalSheetValues =
    ({IntervalRecord<DateTime> transactionDateRange});

/// Shows a [ProjectTransactionsFilterModalSheet] that will return
/// [ProjectTransactionsFilterModalSheetValues] on [Navigator.pop].
Future<ProjectTransactionsFilterModalSheetValues?>
showProjectTransactionsFilterModalSheet(
  BuildContext context, {
  ProjectTransactionsFilterModalSheetValues? initialValues,
}) {
  return showModalBottomSheet(
    context: context,
    builder:
        (_) =>
            ProjectTransactionsFilterModalSheet(initialValues: initialValues),
  );
}

/// Sheet that return values for filtering project transactions on
/// [Navigator.pop].
///
/// Should be build on [showModalBottomSheet] which will return
/// [ProjectTransactionsFilterModalSheetValues].
///
/// Or you can just use [showProjectTransactionsFilterModalSheet].
class ProjectTransactionsFilterModalSheet extends StatefulWidget {
  final ProjectTransactionsFilterModalSheetValues? initialValues;

  const ProjectTransactionsFilterModalSheet({super.key, this.initialValues});

  @override
  State<ProjectTransactionsFilterModalSheet> createState() =>
      _ProjectTransactionsFilterModalSheetState();
}

class _ProjectTransactionsFilterModalSheetState
    extends State<ProjectTransactionsFilterModalSheet> {
  ProjectTransactionsFilterModalSheetValues? get initialValues =>
      widget.initialValues;

  late DatePeriodFilter dateFilter;
  IntervalRecord<DateTime>? customDateFilter;

  /// Whether the [customDateFilter] range is on one date.
  bool get _hasSameDateCustomFilter {
    final interval = customDateFilter;

    if (interval == null) return false;

    final (:begin, :end) = interval;

    return begin!.compareTo(end!) == 0;
  }

  /// Values to return on pop.
  ProjectTransactionsFilterModalSheetValues get _returnValues {
    return (transactionDateRange: customDateFilter ?? dateFilter.toRecord());
  }

  bool get _isValuesChanged => _returnValues != widget.initialValues;

  @override
  void initState() {
    super.initState();

    final initialDateFilter = initialValues?.transactionDateRange;

    if (DatePeriodFilter.weekly.toRecord() == initialDateFilter) {
      dateFilter = DatePeriodFilter.weekly;
    } else if (DatePeriodFilter.monthly.toRecord() == initialDateFilter) {
      dateFilter = DatePeriodFilter.monthly;
    } else if (DatePeriodFilter.annual.toRecord() == initialDateFilter) {
      dateFilter = DatePeriodFilter.annual;
    } else {
      dateFilter = DatePeriodFilter.weekly;
      customDateFilter = initialDateFilter;
    }
  }

  void _onDateFilterSelected(DatePeriodFilter filter) {
    setState(() {
      dateFilter = filter;
      customDateFilter = null;
    });
  }

  void _onCustomDateFilterSelected() async {
    final dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange:
          customDateFilter == null
              ? null
              : DateTimeRange(
                start: customDateFilter!.begin!,
                end: customDateFilter!.end!,
              ),
    );

    if (dateTimeRange == null) return;

    final IntervalRecord<DateTime> result = (
      begin: dateTimeRange.start,
      end: dateTimeRange.end,
    );

    final datePeriodFilter = DatePeriodFilter.tryParse(result);

    setState(() {
      if (datePeriodFilter == null) {
        customDateFilter = result;
      } else {
        _onDateFilterSelected(datePeriodFilter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                title: Text("Project Transactions Filters"),
                actions: [
                  TextButton(
                    onPressed:
                        _isValuesChanged
                            ? () => context.pop(_returnValues)
                            : null,
                    child: Text("Apply"),
                  ),
                ],
              ),
              Text("Period of Transactions", style: textTheme.titleMedium),
              Wrap(
                spacing: 8.0,
                children: [
                  ...DatePeriodFilter.values.map((filter) {
                    return ChoiceChip(
                      label: Text(filter.name.capitalize),
                      selected:
                          dateFilter == filter && customDateFilter == null,
                      onSelected: (isSelected) {
                        if (isSelected) _onDateFilterSelected(filter);
                      },
                    );
                  }),
                  InputChip(
                    label: Text("Custom"),
                    selected: customDateFilter != null,
                    onPressed: _onCustomDateFilterSelected,
                  ),
                ],
              ),
              if (customDateFilter != null)
                Text(
                  "Period ${DateFormat.yMMMd().format(customDateFilter!.begin!)} "
                  "${_hasSameDateCustomFilter ? "" : "~ ${DateFormat.yMMMd().format(customDateFilter!.end!)}"}",
                ).applyOpacity(opacity: 0.6),
            ],
          ),
        );
      },
    );
  }
}
