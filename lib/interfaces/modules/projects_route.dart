part of "../modules.dart";

@TypedGoRoute<ProjectsRoute>(
  path: "/projects",
  routes: [createProjectDeco, projectDetailDeco],
)
class ProjectsRoute extends GoRouteData {
  const ProjectsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProjectsScreen();
  }
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  VoidCallback _onProjectTap(BuildContext context, Project project) {
    return () => ProjectDetailRoute(project.id).go(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Projects")),
      body: Consumer(
        builder: (context, ref, child) {
          final projectsAsync = ref.watch(projectsProvider);

          final isFirstLoad =
              !projectsAsync.hasValue && projectsAsync.isLoading;

          if (isFirstLoad) return child!;

          final projects = projectsAsync.value!;
          final textTheme = context.textTheme;

          if (projects.isEmpty) {
            return Center(
              child: SizedBox(
                width: 400.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No projects yet", style: textTheme.titleLarge),
                    Text(
                      "Try create your first project",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600.0,
              mainAxisExtent: 160.0,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return ProjectCard(
                project,
                onTap: _onProjectTap(context, project),
              );
            },
          );
        },
        child: const AppLoader(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => const CreateProjectRoute().go(context),
        label: Text("Create"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
