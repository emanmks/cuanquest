import 'package:drift/drift.dart';

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

class PlayerProfiles extends Table {
  TextColumn get id => text()();
  IntColumn get totalXp => integer()();
  IntColumn get hp => integer()();
  IntColumn get streakCount => integer()();
  TextColumn get lastLogDate => text()(); // ISO8601
  TextColumn get lastActiveMonth => text()(); // 'MM-YYYY'

  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()(); // TransactionCategory.name
  TextColumn get type => text()(); // TransactionType.name
  BoolColumn get isEssential => boolean()();
  TextColumn get note => text()();
  TextColumn get createdAt => text()(); // ISO8601
  TextColumn get monthYear => text()(); // 'MM-YYYY'

  @override
  Set<Column> get primaryKey => {id};
}

class Rewards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get xpCost => integer()();
  TextColumn get imagePath => text()(); // emoji

  @override
  Set<Column> get primaryKey => {id};
}

class BudgetCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get emoji => text()();
  TextColumn get monthYear => text()(); // 'MM-YYYY'

  @override
  Set<Column> get primaryKey => {id};
}

class BudgetPosts extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // BudgetPostType.name
  RealColumn get amount => real()();
  TextColumn get monthYear => text()(); // 'MM-YYYY'

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [PlayerProfiles, Transactions, Rewards, BudgetCategories, BudgetPosts],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
