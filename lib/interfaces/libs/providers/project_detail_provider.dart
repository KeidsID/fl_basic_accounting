import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";

part "project_detail_provider.g.dart";

@riverpod
class ProjectDetail extends _$ProjectDetail {
  @override
  Project? build(int projectId) {
    final projects = ref.watch(projectsProvider).valueOrNull ?? [];

    return projects.where((p) => p.id == projectId).firstOrNull;
  }

  Future<Project?> updateProject({String? name, String? description}) async {
    final project = stateOrNull;

    if (project == null) return null;

    final updatedName = name ?? project.name;

    return ref
        .read(projectsProvider.notifier)
        .updateProject(
          project.copyWith(name: updatedName, description: description),
        );
  }

  Future<Project?> deleteProject() async {
    final project = stateOrNull;

    if (project == null) return null;

    return ref.read(projectsProvider.notifier).deleteById(project.id);
  }
}
