import 'package:flutter/material.dart';
import 'package:cuanquest/core/theme/app_colors.dart';

/// A Neo-Brutalism button: presses down with a satisfying snap animation.
class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.borderColor = AppColors.border,
    this.textColor = AppColors.onPrimary,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final IconData? icon;
  final bool expanded;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);

  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: disabled ? null : _onTapDown,
      onTapUp: disabled ? null : _onTapUp,
      onTapCancel: disabled ? null : _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.expanded ? double.infinity : null,
        transform: _pressed
            ? Matrix4.translationValues(4, 4, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceVariant
              : widget.color,
          border: Border.all(
            color: disabled ? AppColors.borderMuted : widget.borderColor,
            width: 2,
          ),
          boxShadow: (_pressed || disabled)
              ? null
              : [
                  BoxShadow(
                    color: widget.borderColor,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisSize:
              widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.textColor, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: disabled ? AppColors.onSurface : widget.textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
