import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/budget/providers/budget_posts_provider.dart';

class AddPostSheet extends ConsumerStatefulWidget {
  const AddPostSheet({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<AddPostSheet> createState() => _AddPostSheetState();
}

class _AddPostSheetState extends ConsumerState<AddPostSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _type = BudgetPostType.max;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final raw =
        _amountController.text.replaceAll('.', '').replaceAll(',', '');
    ref.read(budgetPostsProvider.notifier).add(
          categoryId: widget.categoryId,
          name: _nameController.text.trim(),
          type: _type,
          amount: double.parse(raw),
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
              Text('Add Budget Post', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 20),

              Text('Name', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'e.g. Rent',
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
              const SizedBox(height: 20),

              Text('Type', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TypeToggle(
                    label: 'MAX',
                    description: 'Spending cap',
                    selected: _type == BudgetPostType.max,
                    onTap: () => setState(() => _type = BudgetPostType.max),
                  ),
                  const SizedBox(width: 8),
                  _TypeToggle(
                    label: 'FIXED',
                    description: 'Exact amount',
                    selected: _type == BudgetPostType.fixed,
                    onTap: () => setState(() => _type = BudgetPostType.fixed),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Amount', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixText: 'Rp  ',
                  prefixStyle: theme.textTheme.bodyLarge
                      ?.copyWith(color: AppColors.onSurface),
                  hintText: '0',
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
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              GameButton(
                label: 'ADD POST',
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

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderMuted,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.borderMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
