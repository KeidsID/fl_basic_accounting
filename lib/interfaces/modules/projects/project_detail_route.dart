import "package:fl_utilities/fl_utilities.dart";
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

class _ProjectScreen extends ConsumerStatefulWidget {
  final Project project;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProjectScreen(this.project, {this.onEdit, this.onDelete});

  @override
  ConsumerState<_ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<_ProjectScreen> {
  Project get project => widget.project;

  IntervalRecord<DateTime> dateFilter = DatePeriodFilter.monthly.toRecord();

  void _handleTransactionsFilterAction() async {
    final result = await showProjectTransactionsFilterModalSheet(
      context,
      initialValues: (transactionDateRange: dateFilter),
    );

    if (result == null) return;

    setState(() {
      dateFilter = result.transactionDateRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectTransactionsAsync = ref.watch(
      projectTransactionsProvider(
        project.id,
        transactionDateFilter: dateFilter,
      ),
    );
    final isLoading = projectTransactionsAsync.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: _buildBody(context, projectTransactionsAsync),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: isLoading ? null : _handleTransactionsFilterAction,
                  icon: Icon(Icons.filter_alt_outlined),
                  tooltip: "Filter Transactions",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<List<ProjectTransaction>> projectTransactionsAsync,
  ) {
    final Project(
      :name,
      :description,
      :totalCashIn,
      :totalCashOut,
      :totalCash,
    ) = widget.project;

    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = theme.textTheme;

    final sectionMargin = EdgeInsets.all(24.0).copyWith(bottom: 0.0);

    return CustomScrollView(
      slivers: <Widget>[
        SliverSectionCard(
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
                    Text(description.fallbackWith("No project description.")),
                  ],
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: widget.onEdit,
              label: Text("Edit Details"),
              icon: Icon(Icons.edit_outlined),
            ),
          ],
        ),
        SliverSectionCard(
          margin: sectionMargin,
          spacing: 4.0,
          header: Text("Total Cash"),
          contents: [
            Text(
              NumberFormat.compactCurrency(symbol: "\$").format(totalCash),
              style: textTheme.titleLarge,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${NumberFormat.compact().format(totalCashIn)} ",
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
              ),
            ),
          ],
        ),
        SliverSectionCard(
          margin: sectionMargin,
          header: Text("Cashflow"),
          contents: projectTransactionsAsync.maybeWhen<List<Widget>>(
            orElse: () => [AppLoader()],
            data: (transactions) {
              return [
                CashflowChart(
                  transactions,
                  header: Text(
                    "Period "
                    "${DateFormat.yMMMd().format(dateFilter.begin!)} until "
                    "${DateFormat.yMMMd().format(dateFilter.end!)}",
                  ),
                  fallbackBuilder: (context) {
                    return Text(
                      "No transactions for Period "
                      "${DateFormat.yMMMd().format(dateFilter.begin!)} until "
                      "${DateFormat.yMMMd().format(dateFilter.end!)}",
                    );
                  },
                ),
              ];
            },
          ),
        ),
        SliverSectionCard(
          margin: sectionMargin.copyWith(bottom: sectionMargin.top),
          header: Text("Danger Zone"),
          contents: [
            OutlinedErrorButton.icon(
              onPressed: widget.onDelete,
              label: Text("Delete Project"),
              icon: Icon(Icons.delete_outline),
            ),
          ],
        ),
      ],
    );
  }
}
