import "package:flutter/material.dart";

import "package:app/domain/entities.dart";
import "package:app/libs/extensions.dart";

class ProjectCard extends StatelessWidget {
  final Project project;

  final VoidCallback? onTap;

  const ProjectCard(this.project, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Project(:name, :description, :totalCash) = project;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final titleWidget = Text(
      name,
      style: textTheme.headlineMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final cashWidget = Text(
      "\$${totalCash.toStringAsFixed(2)}",
      style: textTheme.titleMedium,
    );
    final descriptionWidget = Text(
      description.fallbackWith("No description"),
      style: textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );

    return Card.outlined(
      child: InkWell(
        onTap: onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [titleWidget, cashWidget, descriptionWidget],
          ),
        ),
      ),
    );
  }
}
