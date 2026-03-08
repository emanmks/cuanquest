import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/features/armory/providers/rewards_provider.dart';

const _emojis = [
  '👟', '👗', '💻', '🎮', '🎵', '📱', '✈️', '🍕',
  '🎬', '👜', '⌚', '📷', '🎸', '📚', '🎯', '🌴',
  '🚗', '🎁', '🏠', '🎨', '🍰', '⚽', '💅', '🛍️',
];

class AddRewardSheet extends ConsumerStatefulWidget {
  const AddRewardSheet({super.key});

  @override
  ConsumerState<AddRewardSheet> createState() => _AddRewardSheetState();
}

class _AddRewardSheetState extends ConsumerState<AddRewardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _xpController = TextEditingController();

  var _selectedEmoji = _emojis.first;

  @override
  void dispose() {
    _nameController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(rewardsProvider.notifier).add(
          name: _nameController.text.trim(),
          xpCost: int.parse(_xpController.text),
          emoji: _selectedEmoji,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text('Add to Armory', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 20),

                // Emoji picker
                Text('Choose an icon', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(
                      color: AppColors.borderMuted,
                      width: 2,
                    ),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _emojis
                        .map(
                          (e) => GestureDetector(
                            onTap: () => setState(() => _selectedEmoji = e),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedEmoji == e
                                    ? AppColors.primaryContainer
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _selectedEmoji == e
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                Text('Reward name', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.onBackground),
                  decoration: InputDecoration(
                    hintText: 'e.g. New Sneakers',
                    hintStyle: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppColors.borderMuted),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.borderMuted, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter a reward name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // XP cost
                Text('XP cost to unlock', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _xpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.onBackground),
                  decoration: InputDecoration(
                    hintText: 'e.g. 100, 250, 500',
                    hintStyle: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppColors.borderMuted),
                    suffixText: 'XP',
                    suffixStyle: const TextStyle(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.borderMuted, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: AppColors.error, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter an XP cost';
                    final n = int.tryParse(v);
                    if (n == null || n < 10) return 'Minimum 10 XP';
                    if (n > 9999) return 'Maximum 9999 XP';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                GameButton(
                  label: 'ADD TO ARMORY',
                  icon: Icons.shield_rounded,
                  expanded: true,
                  color: AppColors.secondary,
                  textColor: AppColors.onSecondary,
                  borderColor: AppColors.border,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
