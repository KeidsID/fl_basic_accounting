import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";
import "package:app/interfaces/libs/widgets.dart";
import "package:app/libs/extensions.dart";

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
      builder: (context) {
        return ProjectFormDialog(
          variant: ProjectFormDialogVariant.edit,
          project: project,
        );
      },
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

    if (project == null) return _buildNotFoundScreen(context);

    return _ProjectScreen(
      project,
      onEdit: _onEdit(context, project),
      onDelete: _onDelete(context, ref),
    );
  }

  Widget _buildNotFoundScreen(BuildContext context) {
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

class _ProjectScreen extends HookWidget {
  final Project project;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProjectScreen(this.project, {this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final Project(:name, :description) = project;

    final appBar = AppBar(title: Text(name));

    final slivers = <Widget>[
      SliverSectionCard(
        margin: EdgeInsets.all(24.0).copyWith(bottom: 0.0),
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
            onPressed: onEdit,
            label: Text("Edit Details"),
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
      SliverSectionCard(
        header: Text("Danger Zone"),
        contents: [
          OutlinedErrorButton.icon(
            onPressed: onDelete,
            label: Text("Delete Project"),
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
    ];

    return Scaffold(appBar: appBar, body: CustomScrollView(slivers: slivers));
  }
}
