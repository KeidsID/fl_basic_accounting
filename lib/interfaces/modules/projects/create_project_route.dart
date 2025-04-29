import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "package:app/interfaces/libs/router.dart";
import "package:app/interfaces/libs/widgets.dart";
import "package:app/interfaces/modules.dart";

const createProjectDeco = TypedGoRoute<CreateProjectRoute>(path: "new");

class CreateProjectRoute extends GoRouteData {
  final String? name;
  final String? description;

  const CreateProjectRoute({this.name, this.description});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DialogRoutePage(
      builder: (context) {
        return ProjectFormDialog(
          initialValues: ProjectFormDialogInitialValues(
            name: name,
            description: description,
          ),
          fieldsObserver: (fields) {
            final (:name, :description) = fields;

            CreateProjectRoute(
              name: name.isEmpty ? null : name,
              description: description.isEmpty ? null : description,
            ).go(context);
          },
        );
      },
    );
  }
}
