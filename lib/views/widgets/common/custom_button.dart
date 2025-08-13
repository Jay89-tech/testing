// lib/views/widgets/common/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? style;
  final Widget? loadingWidget;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.isLoading = false,
    this.isEnabled = true,
    this.style,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.primaryColor;
    final defaultTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: style ??
            ElevatedButton.styleFrom(
              backgroundColor: defaultBackgroundColor,
              foregroundColor: defaultTextColor,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[500],
              elevation: isEnabled ? 2 : 0,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding,
            ),
        child: isLoading
            ? (loadingWidget ??
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                  ),
                ))
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: fontSize + 2),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final double borderWidth;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final bool isEnabled;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = borderColor ?? theme.primaryColor;
    final defaultTextColor = textColor ?? theme.primaryColor;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: defaultTextColor,
          disabledForegroundColor: Colors.grey[400],
          side: BorderSide(
            color: isEnabled ? defaultBorderColor : Colors.grey[300]!,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: fontSize + 2),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final String? tooltip;
  final bool isEnabled;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize = 24,
    this.borderRadius = 12,
    this.tooltip,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.primaryColor;
    final defaultIconColor = iconColor ?? Colors.white;

    Widget button = SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultIconColor,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          elevation: isEnabled ? 2 : 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final IconData? icon;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isUnderlined;
  final bool isEnabled;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.icon,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.isUnderlined = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextColor = textColor ?? theme.primaryColor;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: defaultTextColor,
        disabledForegroundColor: Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              decoration: isUnderlined ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;
  final String? tooltip;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isExtended = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.primaryColor;
    final defaultForegroundColor = foregroundColor ?? Colors.white;

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        tooltip: tooltip,
        icon: Icon(icon),
        label: Text(
          label!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: defaultBackgroundColor,
      foregroundColor: defaultForegroundColor,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}

class CustomButtonGroup extends StatelessWidget {
  final List<CustomButtonGroupItem> buttons;
  final MainAxisAlignment alignment;
  final double spacing;
  final bool isVertical;

  const CustomButtonGroup({
    super.key,
    required this.buttons,
    this.alignment = MainAxisAlignment.spaceEvenly,
    this.spacing = 8,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Column(
        mainAxisAlignment: alignment,
        children: buttons
            .map((button) => Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing / 2),
                  child: button.child,
                ))
            .toList(),
      );
    }

    return Row(
      mainAxisAlignment: alignment,
      children: buttons
          .map((button) => Expanded(
                flex: button.flex,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: button.child,
                ),
              ))
          .toList(),
    );
  }
}

class CustomButtonGroupItem {
  final Widget child;
  final int flex;

  const CustomButtonGroupItem({
    required this.child,
    this.flex = 1,
  });
}