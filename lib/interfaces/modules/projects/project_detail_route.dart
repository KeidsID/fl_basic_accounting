import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";
import "package:app/interfaces/libs/widgets.dart";

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

class _ProjectScreen extends StatelessWidget {
  final Project project;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ProjectScreen(this.project, {this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final Project(:name, :description) = project;

    final theme = context.theme;
    final textTheme = theme.textTheme;

    final appBar = SliverAppBar(title: Text('"$name" Project'));

    final children = <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text(description ?? "No project description."),
          OutlinedButton.icon(
            onPressed: onEdit,
            label: Text("Edit Details"),
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),

      // Danger Zone section
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text("Danger Zone", style: textTheme.titleLarge),
          OutlinedErrorButton.icon(
            onPressed: onDelete,
            label: Text("Delete Project"),
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar,
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList.separated(
              itemCount: children.length,
              itemBuilder: (_, index) => children[index],
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
