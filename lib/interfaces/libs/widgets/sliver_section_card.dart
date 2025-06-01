import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:sliver_tools/sliver_tools.dart";

/// {@template app.interfaces.libs.widgets.SliverSectionCard}
/// Simple card that contain [header] and [contents].
///
/// Can only be used on [CustomScrollView.slivers].
/// {@endtemplate}
class SliverSectionCard extends StatelessWidget {
  /// Alignment to apply on [contents].
  final CrossAxisAlignment crossAxisAlignment;

  /// The empty space that surrounds the card.
  final EdgeInsets margin;

  /// The empty space that surrounds the card contents.
  ///
  /// The [EdgeInsets.bottom] will affect the gap between [header] and [contents].
  final EdgeInsets padding;

  /// How much space to place between [contents].
  final double spacing;

  /// Widget that act as header.
  ///
  /// Typically a [Text].
  final Widget header;

  /// Card contents that build below [header].
  final List<Widget> contents;

  /// {@macro app.interfaces.libs.widgets.SliverSectionCard}
  const SliverSectionCard({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.margin = const EdgeInsets.all(24.0),
    this.padding = const EdgeInsets.all(16.0),
    this.spacing = 16.0,
    required this.header,
    this.contents = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPadding(
          // Horizontal margin + Bottom margin
          padding: margin.copyWith(top: 0.0),
          sliver: SliverStack(
            insetOnOverlap: true,
            children: [
              SliverPositioned.fill(
                top: margin.top,
                child: Card.outlined(margin: EdgeInsets.zero),
              ),
              MultiSliver(
                children: [
                  SliverPinnedHeader(
                    child: Padding(
                      padding: padding.copyWith(
                        // filling margin gap on pinned
                        top: padding.top + margin.top,
                        bottom: 0.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          DefaultTextStyle(
                            style: textTheme.titleLarge ?? TextStyle(),
                            child: header,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SliverClip(
                    child: SliverPadding(
                      padding: padding.copyWith(top: 8.0),
                      sliver: _buildList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return SliverList.separated(
      itemCount: contents.length,
      itemBuilder: (_, index) {
        final content = contents[index];

        if (crossAxisAlignment == CrossAxisAlignment.stretch) {
          return content;
        }

        return Container(
          alignment: switch (crossAxisAlignment) {
            CrossAxisAlignment.start => Alignment.centerLeft,
            CrossAxisAlignment.end => Alignment.centerRight,
            _ => Alignment.center,
          },
          child: content,
        );
      },
      separatorBuilder: (_, __) => SizedBox(width: 0.0, height: spacing),
    );
  }
}
