import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/core/core.dart';
import 'package:cuanquest/domain/domain.dart';
import 'package:cuanquest/features/ledger/providers/transactions_provider.dart';
import 'package:cuanquest/features/profile/providers/player_profile_provider.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  var _type = TransactionType.expense;
  var _selectedCategory = TransactionCategory.food;
  var _isEssential = true;

  List<TransactionCategory> get _categories =>
      _type == TransactionType.expense
          ? TransactionCategory.expenseCategories
          : TransactionCategory.incomeCategories;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final raw = _amountController.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.parse(raw);

    final oldLevel = GamificationService.levelFromTotalXp(
      ref.read(playerProfileProvider).totalXp,
    );

    final txn = ref.read(transactionsProvider.notifier).add(
          amount: amount,
          category: _selectedCategory,
          type: _type,
          isEssential:
              _type == TransactionType.income ? true : _isEssential,
          note: _noteController.text.trim(),
        );

    ref.read(playerProfileProvider.notifier).applyTransaction(txn);

    final newProfile = ref.read(playerProfileProvider);
    final newLevel = GamificationService.levelFromTotalXp(newProfile.totalXp);
    final xpGained = GamificationService.xpGainForTransaction(txn);

    if (newLevel > oldLevel) {
      await showDialog<void>(
        context: context,
        builder: (_) => LevelUpDialog(level: newLevel, xpGained: xpGained),
      );
    }

    if (mounted) Navigator.of(context).pop();
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

                Text('Log Transaction', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),

                // Type toggle
                Row(
                  children: [
                    _TypeToggle(
                      label: 'EXPENSE',
                      selected: _type == TransactionType.expense,
                      color: AppColors.error,
                      onTap: () => setState(() {
                        _type = TransactionType.expense;
                        _selectedCategory = TransactionCategory.food;
                      }),
                    ),
                    const SizedBox(width: 8),
                    _TypeToggle(
                      label: 'INCOME',
                      selected: _type == TransactionType.income,
                      color: AppColors.success,
                      onTap: () => setState(() {
                        _type = TransactionType.income;
                        _selectedCategory = TransactionCategory.salary;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Amount
                Text('Amount', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: AppColors.onBackground),
                  decoration: InputDecoration(
                    prefixText: 'Rp  ',
                    prefixStyle: theme.textTheme.headlineMedium
                        ?.copyWith(color: AppColors.onSurface),
                    hintText: '0',
                    hintStyle: theme.textTheme.headlineMedium
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
                    if (v == null || v.isEmpty) return 'Enter an amount';
                    final n = double.tryParse(v);
                    if (n == null || n <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                Text('Category', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories
                      .map(
                        (cat) => _CategoryChip(
                          category: cat,
                          selected: _selectedCategory == cat,
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),

                // Essential toggle (expense only)
                if (_type == TransactionType.expense) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Essential?',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text(
                              _isEssential
                                  ? 'Neutral — no Mana drain'
                                  : 'Want — drains your Mana!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _isEssential
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isEssential,
                        onChanged: (v) => setState(() => _isEssential = v),
                        activeThumbColor: AppColors.secondary,
                        inactiveThumbColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Note
                Text('Note (optional)', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'e.g. Lunch at warung',
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
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Submit
                GameButton(
                  label: 'LOG TRANSACTION',
                  icon: Icons.bolt_rounded,
                  expanded: true,
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

// ── Internal widgets ──────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.surface,
          border: Border.all(
            color: selected ? color : AppColors.borderMuted,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color,
                    offset: const Offset(3, 3),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final TransactionCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? category.color.withValues(alpha: 0.2)
              : AppColors.surface,
          border: Border.all(
            color: selected ? category.color : AppColors.borderMuted,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color:
                  selected ? category.color : AppColors.onSurface,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              category.displayName,
              style: TextStyle(
                color: selected
                    ? category.color
                    : AppColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
