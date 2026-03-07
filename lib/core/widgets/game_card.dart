import 'package:flutter/material.dart';
import 'package:cuanquest/core/theme/app_colors.dart';

/// A Neo-Brutalism card: flat color, solid border, hard offset shadow.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.child,
    this.color,
    this.borderColor = AppColors.border,
    this.shadowColor = AppColors.primary,
    this.padding = const EdgeInsets.all(16),
    this.shadowOffset = const Offset(4, 4),
  });

  final Widget child;
  final Color? color;
  final Color borderColor;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: shadowOffset,
            blurRadius: 0,
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
