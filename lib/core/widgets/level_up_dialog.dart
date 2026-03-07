import 'package:flutter/material.dart';
import 'package:cuanquest/core/theme/app_colors.dart';
import 'package:cuanquest/core/widgets/game_button.dart';

class LevelUpDialog extends StatefulWidget {
  const LevelUpDialog({
    super.key,
    required this.level,
    required this.xpGained,
  });

  final int level;
  final int xpGained;

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border.fromBorderSide(
                BorderSide(color: AppColors.tertiary, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiary,
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '⚡ LEVEL UP!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 88,
                  height: 88,
                  color: AppColors.tertiaryContainer,
                  child: Center(
                    child: Text(
                      '${widget.level}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'You reached Level ${widget.level}!',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '+${widget.xpGained} XP gained',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 28),
                GameButton(
                  label: 'AWESOME!',
                  expanded: true,
                  color: AppColors.tertiary,
                  textColor: Colors.black,
                  borderColor: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
