import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";

/// Style for [OutlinedErrorButton].
ButtonStyle? _getButtonStyle(BuildContext context) {
  final theme = context.theme;
  final colorScheme = theme.colorScheme;

  final defaultStyle = theme.outlinedButtonTheme.style;
  final buttonColor = colorScheme.error;
  final disabledColor = buttonColor.withValues(alpha: 0.5);

  final borderStyle = defaultStyle?.side
      ?.resolve({WidgetState.focused})
      ?.copyWith(color: buttonColor);
  final disabledBorderStyle = borderStyle?.copyWith(color: disabledColor);

  return OutlinedButton.styleFrom(
    foregroundColor: buttonColor,
    iconColor: buttonColor,
    disabledForegroundColor: disabledColor,
    disabledIconColor: disabledColor,
  ).copyWith(
    side: WidgetStateBorderSide.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return disabledBorderStyle;

      return borderStyle;
    }),
  );
}

/// [OutlinedButton] variant that applies [ColorScheme.error] color.
class OutlinedErrorButton extends OutlinedButton {
  const OutlinedErrorButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
    required super.child,
  });

  static Widget icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? icon,
    required Widget label,
    IconAlignment? iconAlignment,
  }) {
    return Builder(
      builder: (context) {
        return OutlinedButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: _getButtonStyle(context),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          statesController: statesController,
          icon: icon,
          label: label,
          iconAlignment: iconAlignment,
        );
      },
    );
  }

  @override
  State<ButtonStyleButton> createState() => _OutlinedDangerButtonState();
}

class _OutlinedDangerButtonState extends State<OutlinedErrorButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      style: _getButtonStyle(context),
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      statesController: widget.statesController,
      child: widget.child,
    );
  }
}
