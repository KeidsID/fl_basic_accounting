import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";
import "package:app/interfaces/libs/widgets.dart";
import "package:app/libs/enums.dart";
import "package:app/libs/extensions.dart";
import "package:app/libs/types.dart";

const projectDetailDeco = TypedGoRoute<ProjectDetailRoute>(
  path: "view/:projectId",
);

class ProjectDetailRoute extends GoRouteData {
  final int projectId;

  const ProjectDetailRoute(this.projectId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProjectDetailScreen(projectId);
  }
}

class ProjectDetailScreen extends ConsumerWidget {
  final int projectId;

  const ProjectDetailScreen(this.projectId, {super.key});

  VoidCallback _onEdit(BuildContext context, Project project) {
    return () => showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(project: project),
    );
  }

  VoidCallback _onDelete(BuildContext context, WidgetRef ref) {
    return () async {
      await ref.read(projectDetailProvider(projectId).notifier).deleteProject();

      if (context.mounted) return Navigator.of(context).pop();
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectDetailProvider(projectId));

    if (project == null) return const _ProjectNotFoundScreen();

    return _ProjectScreen(
      project,
      onEdit: _onEdit(context, project),
      onDelete: _onDelete(context, ref),
    );
  }
}

class _ProjectNotFoundScreen extends StatelessWidget {
  const _ProjectNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Project Not Found")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Project Not Found", style: textTheme.titleLarge),
            Text(
              "It may have been deleted recently.",
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class _ProjectScreen extends StatefulWidget {
  final Project project;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProjectScreen(this.project, {this.onEdit, this.onDelete});

  @override
  State<_ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<_ProjectScreen> {
  Project get project => widget.project;

  ProjectTransactionsFilterModalSheetValues filters = (
    transactionDateRange: DatePeriodFilter.monthly.toRecord(),
  );

  ProjectTransactionsProvider get transactionsProvider =>
      projectTransactionsProvider(
        project.id,
        filters: ProjectTransactionsProviderFilters(
          dateFilter: filters.transactionDateRange,
        ),
      );

  void _handleTransactionsFilterAction() async {
    final ProjectTransactionsFilterModalSheetValues? result =
        await showProjectTransactionsFilterModalSheet(
          context,
          initialValues: filters,
        );

    if (result == null) return;

    setState(() => filters = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: _ProjectScreenBody(
        project: project,
        transactionsProvider: transactionsProvider,
        onProjectEdit: widget.onEdit,
        onProjectDelete: widget.onDelete,
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final projectTransactionsAsync = ref.watch(transactionsProvider);
          final isLoading = projectTransactionsAsync.isLoading;

          return BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: isLoading ? null : _handleTransactionsFilterAction,
                  icon: Icon(Icons.filter_alt_outlined),
                  tooltip: "Filter Transactions",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProjectScreenBody extends StatelessWidget {
  final Project project;
  final ProjectTransactionsProvider transactionsProvider;

  final VoidCallback? onProjectEdit;
  final VoidCallback? onProjectDelete;

  const _ProjectScreenBody({
    required this.project,
    required this.transactionsProvider,
    this.onProjectEdit,
    this.onProjectDelete,
  });

  IntervalRecord<DateTime> get dateFilter =>
      transactionsProvider.filters.dateFilter ?? (begin: null, end: null);

  Widget _sliverWrap(List<Widget> children) {
    return SliverToBoxAdapter(child: Wrap(children: children));
  }

  @override
  Widget build(BuildContext context) {
    final Project(
      :name,
      :description,
      :totalCashIn,
      :totalCashOut,
      :totalCash,
    ) = project;

    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = theme.textTheme;

    final sectionMargin = EdgeInsets.all(24.0).copyWith(bottom: 0.0);

    return CustomScrollView(
      slivers: <Widget>[
        // Project details section
        _sliverWrap(
          [
            SectionCard(
              margin: sectionMargin,
              header: Text("Project Details"),
              contents: [
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(120.0),
                    1: FixedColumnWidth(16.0),
                  },
                  children: [
                    TableRow(children: [Text("Name"), Text(":"), Text(name)]),
                    TableRow(
                      children: [
                        Text("Description"),
                        Text(":"),
                        Text(
                          description.fallbackWith("No project description."),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: onProjectEdit,
                  label: Text("Edit Details"),
                  icon: Icon(Icons.edit_outlined),
                ),
              ],
            ),
            SectionCard(
              margin: sectionMargin,
              header: Text("Total Cash"),
              contents: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: NumberFormat.compactCurrency(
                          symbol: "\$",
                        ).format(totalCash),
                        style: textTheme.titleLarge,
                      ),
                      if (totalCash != 0.0) ...[
                        TextSpan(
                          text:
                              "\n${NumberFormat.compact().format(totalCashIn)} ",
                          style: textTheme.bodyMedium?.apply(
                            color: colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: NumberFormat.compact().format(totalCashOut),
                          style: textTheme.bodyMedium?.apply(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ].map((child) => SizedBox(width: 600.0, child: child)).toList(),
        ),

        // Cashflow chart section
        Consumer(
          builder: (context, ref, _) {
            final transactionsAsync = ref.watch(transactionsProvider);

            final isLoading = transactionsAsync.isLoading;
            final transactions =
                transactionsAsync.valueOrNull ?? <ProjectTransaction>[];

            return SliverSectionCard(
              margin: sectionMargin,
              header: Text("Cashflow"),
              contents: [
                if (isLoading) SizedBox(height: 300.0, child: AppLoader()),
                if (!isLoading)
                  CashflowChart(
                    transactions,
                    header: Text(
                      "Period "
                      "${DateFormat.yMMMd().format(dateFilter.begin!)} until "
                      "${DateFormat.yMMMd().format(dateFilter.end!)}",
                    ),
                    fallbackBuilder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No transactions for Period "
                            "${DateFormat.yMMMd().format(dateFilter.begin!)} until "
                            "${DateFormat.yMMMd().format(dateFilter.end!)}",
                          ),
                          if (kDebugMode)
                            DefaultTextStyle(
                              style: textTheme.bodyMedium!.copyWith(
                                color: colorScheme.error,
                              ),
                              child: transactionsAsync.maybeWhen(
                                orElse: () => SizedBox.shrink(),
                                error: (error, stackTrace) {
                                  return Text("$error\n$stackTrace");
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
              ],
            );
          },
        ),

        _sliverWrap(
          [
            SectionCard(
              margin: sectionMargin.copyWith(bottom: sectionMargin.top),
              header: Text("Danger Zone"),
              contents: [
                OutlinedErrorButton.icon(
                  onPressed: onProjectDelete,
                  label: Text("Delete Project"),
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ].map((child) => SizedBox(width: 600.0, child: child)).toList(),
        ),
      ],
    );
  }
}
