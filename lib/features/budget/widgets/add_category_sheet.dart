import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/features/budget/providers/budget_categories_provider.dart';

/// Quick emoji picker — a curated set of common budget emojis.
const _emojis = [
  '🏠', '🚗', '🍔', '🛒', '💊', '📚', '✈️', '🎮',
  '👗', '💄', '☕', '🎬', '💪', '🐾', '🎁', '💰',
  '📱', '💡', '🌿', '🏋️',
];

class AddCategorySheet extends ConsumerStatefulWidget {
  const AddCategorySheet({super.key});

  @override
  ConsumerState<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends ConsumerState<AddCategorySheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedEmoji = _emojis.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(budgetCategoriesProvider.notifier).add(
          name: _nameController.text.trim(),
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
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text('New Budget Category', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 20),

              Text('Choose Emoji', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _emojis
                    .map(
                      (e) => GestureDetector(
                        onTap: () => setState(() => _selectedEmoji = e),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _selectedEmoji == e
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.surface,
                            border: Border.all(
                              color: _selectedEmoji == e
                                  ? AppColors.primary
                                  : AppColors.borderMuted,
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
              const SizedBox(height: 20),

              Text('Category Name', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'e.g. Housing',
                  hintStyle: theme.textTheme.bodyMedium
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
                    borderSide: BorderSide(color: AppColors.error, width: 2),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.error, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 28),

              GameButton(
                label: 'ADD CATEGORY',
                icon: Icons.add_rounded,
                expanded: true,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
