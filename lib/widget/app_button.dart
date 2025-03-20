// lib/widgets/buttons/app_button.dart
import 'package:flutter/material.dart';

enum AppButtonType { filled, outlined }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final MainAxisAlignment iconAlignment;
  final double iconSpacing;
  final bool disabled;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? disabledBorderColor;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.filled,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.padding,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.iconAlignment = MainAxisAlignment.center,
    this.iconSpacing = 8.0,
    this.disabled = false,
    this.disabledColor,
    this.disabledTextColor,
    this.disabledBorderColor,
  }) : super(key: key);

  // Factory constructor for filled button
  factory AppButton.filled({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    MainAxisAlignment iconAlignment = MainAxisAlignment.center,
    double iconSpacing = 8.0,
    bool disabled = false,
    Color? disabledColor,
    Color? disabledTextColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.filled,
      isLoading: isLoading,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      iconAlignment: iconAlignment,
      iconSpacing: iconSpacing,
      disabled: disabled,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
    );
  }

  // Factory constructor for outlined button
  factory AppButton.outlined({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
    double? height,
    Color? borderColor,
    Color? textColor,
    double borderWidth = 1.0,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    MainAxisAlignment iconAlignment = MainAxisAlignment.center,
    double iconSpacing = 8.0,
    bool disabled = false,
    Color? disabledBorderColor,
    Color? disabledTextColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outlined,
      isLoading: isLoading,
      width: width,
      height: height,
      borderColor: borderColor,
      textColor: textColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      textStyle: textStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      iconAlignment: iconAlignment,
      iconSpacing: iconSpacing,
      disabled: disabled,
      disabledBorderColor: disabledBorderColor,
      disabledTextColor: disabledTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default colors based on button type and theme
    final defaultBackgroundColor = type == AppButtonType.filled
        ? theme.primaryColor
        : Colors.transparent;
    final defaultTextColor = type == AppButtonType.filled
        ? theme.primaryTextTheme.labelLarge?.color ?? Colors.white
        : theme.primaryColor;
    final defaultBorderColor = theme.primaryColor;

    // Active colors (considering passed parameters)
    final activeBackgroundColor = backgroundColor ?? defaultBackgroundColor;
    final activeTextColor = textColor ?? defaultTextColor;
    final activeBorderColor = borderColor ?? defaultBorderColor;

    // Disabled colors
    final inactiveBackgroundColor = disabledColor ??
        (type == AppButtonType.filled
            ? theme.disabledColor.withOpacity(0.2)
            : Colors.transparent);
    final inactiveTextColor =
        disabledTextColor ?? theme.disabledColor.withOpacity(0.5);
    final inactiveBorderColor =
        disabledBorderColor ?? theme.disabledColor.withOpacity(0.3);

    // Final color determination
    final finalBackgroundColor =
    disabled ? inactiveBackgroundColor : activeBackgroundColor;
    final finalTextColor = disabled ? inactiveTextColor : activeTextColor;
    final finalBorderColor = disabled ? inactiveBorderColor : activeBorderColor;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: finalBackgroundColor,
          foregroundColor: finalTextColor,
          disabledBackgroundColor: inactiveBackgroundColor,
          disabledForegroundColor: inactiveTextColor,
          elevation: type == AppButtonType.filled ? 0 : 0,
          padding: padding,
          side: type == AppButtonType.outlined
              ? BorderSide(
            color: finalBorderColor,
            width: borderWidth,
          )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: type == AppButtonType.filled
                ? BorderSide.none
                : BorderSide(
              color: finalBorderColor,
              width: borderWidth,
            ),
          ),
        ),
        child: isLoading
            ? _loadingIndicator(finalTextColor)
            : _buttonContent(context, finalTextColor),
      ),
    );
  }

  Widget _loadingIndicator(Color color) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buttonContent(BuildContext context, Color textColor) {
    final hasPrefix = prefixIcon != null;
    final hasSuffix = suffixIcon != null;
    final defaultTextStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    final textWidget = Text(
      text,
      style: textStyle?.copyWith(color: textColor) ??
          defaultTextStyle,
      textAlign: TextAlign.center,
    );

    if (!hasPrefix && !hasSuffix) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: iconAlignment,
      children: [
        if (hasPrefix) ...[
          prefixIcon!,
          SizedBox(width: iconSpacing),
        ],
        textWidget,
        if (hasSuffix) ...[
          SizedBox(width: iconSpacing),
          suffixIcon!,
        ],
      ],
    );
  }
}