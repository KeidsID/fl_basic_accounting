import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";

part "project_form_dialog.freezed.dart";

@freezed
sealed class ProjectFormDialogInitialValues
    with _$ProjectFormDialogInitialValues {
  const factory ProjectFormDialogInitialValues({
    String? name,
    String? description,
  }) = _ProjectFormDialogInitialValues;
}

typedef ProjectFormDialogFieldsObserver =
    void Function(({String name, String description}) fields);

typedef _FormFieldControlers =
    ({TextEditingController name, TextEditingController description});

_FormFieldControlers _useFormControllers([
  ProjectFormDialogInitialValues? initialValues,
]) {
  final nameController = useTextEditingController(text: initialValues?.name);
  final descriptionController = useTextEditingController(
    text: initialValues?.description,
  );

  return (name: nameController, description: descriptionController);
}

class ProjectFormDialog extends ConsumerStatefulWidget {
  /// Project to edit, will determine the form variant.
  ///
  /// If not `null`, edit action button will rendered instead of create action.
  final Project? project;

  /// Initial values for the form fields.
  final ProjectFormDialogInitialValues initialValues;

  /// Watch for field changes.
  final ProjectFormDialogFieldsObserver? fieldsObserver;

  const ProjectFormDialog({
    super.key,
    this.project,
    this.initialValues = const ProjectFormDialogInitialValues(),
    this.fieldsObserver,
  });

  @override
  ConsumerState<ProjectFormDialog> createState() {
    return _ProjectFormDialogState();
  }
}

class _ProjectFormDialogState extends ConsumerState<ProjectFormDialog> {
  bool get isCreateVariant => widget.project == null;

  /// Indicated the form is validated once.
  bool hasValidated = false;

  FormFieldValidator<String>? _nameValidator(context) {
    return (value) {
      if (value == null || value.isEmpty) return "Name is required";

      return null;
    };
  }

  VoidCallback? _onCancel(BuildContext context) {
    return () => Navigator.of(context).pop();
  }

  VoidCallback? _onActionExecute(
    BuildContext context,
    _FormFieldControlers controllers,
  ) {
    return () async {
      final form = Form.of(context);

      if (!form.validate()) {
        if (hasValidated) return;

        return setState(() => hasValidated = true);
      }

      (isCreateVariant)
          ? await _createAction(controllers)
          : await _editAction(controllers);

      if (context.mounted) return Navigator.of(context).pop();
    };
  }

  Future<Project?> _createAction(_FormFieldControlers controllers) {
    final name = controllers.name.text;
    final description = controllers.description.text;

    final projectsNotifier = ref.read(projectsProvider.notifier);

    return projectsNotifier.create(name: name, description: description);
  }

  Future<Project?> _editAction(_FormFieldControlers controllers) async {
    if (isCreateVariant) return null;

    final name = controllers.name.text;
    final description = controllers.description.text;

    final projectsNotifier = ref.read(projectsProvider.notifier);

    final updatedName = name.isEmpty ? widget.project!.name : name;

    return projectsNotifier.updateProject(
      widget.project!.copyWith(name: updatedName, description: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final controllers = _useFormControllers(
          widget.initialValues.copyWith(
            name: widget.project?.name,
            description: widget.project?.description,
          ),
        );

        final projectsAsync = ref.watch(projectsProvider);
        final isLoading = projectsAsync.isLoading;

        final theme = context.theme;

        return Form(
          autovalidateMode: switch (hasValidated) {
            true => AutovalidateMode.onUserInteraction,
            false => null,
          },
          child: AlertDialog(
            title: Text(
              isCreateVariant ? "Project Creation" : "Project Update",
            ),
            content: SizedBox(
              width: 600.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16.0,
                children: [
                  TextFormField(
                    controller: controllers.name,
                    decoration: InputDecoration(
                      label: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Name"),
                            TextSpan(
                              text: "*",
                              style: theme.inputDecorationTheme.labelStyle
                                  ?.copyWith(color: theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                      // labelText: "Name",
                      hintText: "The name of your project",
                    ),
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      widget.fieldsObserver?.call((
                        name: value,
                        description: controllers.description.text,
                      ));
                    },
                    validator: _nameValidator(context),
                  ),
                  TextField(
                    controller: controllers.description,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Describe your project",
                    ),
                    maxLines: 3,
                    enabled: !isLoading,
                    onChanged: (value) {
                      widget.fieldsObserver?.call((
                        name: controllers.name.text,
                        description: value,
                      ));
                    },
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: isLoading ? null : _onCancel(context),
                child: const Text("Cancel"),
              ),
              Builder(
                // to receive [Form] from context
                builder: (context) {
                  return FilledButton(
                    onPressed:
                        isLoading
                            ? null
                            : _onActionExecute(context, controllers),
                    child: Text(isCreateVariant ? "Create" : "Update"),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
