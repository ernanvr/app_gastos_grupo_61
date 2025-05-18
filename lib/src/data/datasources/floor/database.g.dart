// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BudgetDao? _budgetDaoInstance;

  TransactionDao? _transactionDaoInstance;

  CategoryDao? _categoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `budget` (`id` INTEGER, `description` TEXT NOT NULL, `initialAmount` REAL NOT NULL, `date` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `category` (`id` INTEGER, `name` TEXT NOT NULL, `isIncome` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transactions` (`id` INTEGER, `categoryId` INTEGER NOT NULL, `budgetId` INTEGER NOT NULL, `description` TEXT NOT NULL, `amount` REAL NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`categoryId`) REFERENCES `category` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`budgetId`) REFERENCES `budget` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `budget_with_balance` AS   SELECT\n      B.id,\n      B.description,\n      B.initialAmount,\n      B.date,\n      B.initialAmount + COALESCE(SUM(CASE WHEN C.isIncome = 1 THEN T.amount ELSE -T.amount END), 0) AS balance\n  FROM\n      budget AS B\n  LEFT JOIN\n      transactions AS T ON B.id = T.budgetId\n  LEFT JOIN\n      category AS C ON T.categoryId = C.id\n  GROUP BY\n      B.id, B.description, B.initialAmount, B.date;\n  ');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `transaction_with_category` AS   SELECT\n      T.id,\n      T.categoryId,\n      C.name AS categoryName, -- Seleccionamos el nombre de la categoría y lo renombramos\n      C.isIncome,\n      T.budgetId,\n      T.description,\n      T.amount,\n      T.date\n  FROM\n      transactions AS T -- Tabla de transacciones (alias T)\n  INNER JOIN\n      category AS C ON T.categoryId = C.id; -- Unimos con la tabla de categorías (alias C) donde el ID de la categoría coincide con el categoryId de la transacción. Usamos INNER JOIN porque una transacción debe tener una categoría asociada para aparecer en esta vista.\n  ');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BudgetDao get budgetDao {
    return _budgetDaoInstance ??= _$BudgetDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }
}

class _$BudgetDao extends BudgetDao {
  _$BudgetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _budgetModelInsertionAdapter = InsertionAdapter(
            database,
            'budget',
            (BudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'initialAmount': item.initialAmount,
                  'date': _dateTimeConverter.encode(item.date)
                }),
        _budgetModelUpdateAdapter = UpdateAdapter(
            database,
            'budget',
            ['id'],
            (BudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'initialAmount': item.initialAmount,
                  'date': _dateTimeConverter.encode(item.date)
                }),
        _budgetModelDeletionAdapter = DeletionAdapter(
            database,
            'budget',
            ['id'],
            (BudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'initialAmount': item.initialAmount,
                  'date': _dateTimeConverter.encode(item.date)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BudgetModel> _budgetModelInsertionAdapter;

  final UpdateAdapter<BudgetModel> _budgetModelUpdateAdapter;

  final DeletionAdapter<BudgetModel> _budgetModelDeletionAdapter;

  @override
  Future<List<BudgetWithBalanceModel>> getBudgets() async {
    return _queryAdapter.queryList('Select * from budget_with_balance',
        mapper: (Map<String, Object?> row) => BudgetWithBalanceModel(
            id: row['id'] as int?,
            description: row['description'] as String,
            initialAmount: row['initialAmount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            balance: row['balance'] as double));
  }

  @override
  Future<BudgetWithBalanceModel?> getBudgetById(int id) async {
    return _queryAdapter.query(
        'Select * from budget_with_balance WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BudgetWithBalanceModel(
            id: row['id'] as int?,
            description: row['description'] as String,
            initialAmount: row['initialAmount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            balance: row['balance'] as double),
        arguments: [id]);
  }

  @override
  Future<int> insertBudget(BudgetModel budget) {
    return _budgetModelInsertionAdapter.insertAndReturnId(
        budget, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateBudget(BudgetModel budget) {
    return _budgetModelUpdateAdapter.updateAndReturnChangedRows(
        budget, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteBudget(BudgetModel budget) {
    return _budgetModelDeletionAdapter.deleteAndReturnChangedRows(budget);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionModelInsertionAdapter = InsertionAdapter(
            database,
            'transactions',
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'budgetId': item.budgetId,
                  'description': item.description,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date)
                }),
        _transactionModelUpdateAdapter = UpdateAdapter(
            database,
            'transactions',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'budgetId': item.budgetId,
                  'description': item.description,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date)
                }),
        _transactionModelDeletionAdapter = DeletionAdapter(
            database,
            'transactions',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'categoryId': item.categoryId,
                  'budgetId': item.budgetId,
                  'description': item.description,
                  'amount': item.amount,
                  'date': _dateTimeConverter.encode(item.date)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionModel> _transactionModelInsertionAdapter;

  final UpdateAdapter<TransactionModel> _transactionModelUpdateAdapter;

  final DeletionAdapter<TransactionModel> _transactionModelDeletionAdapter;

  @override
  Future<List<TransactionWithCategoryModel>> getTransactionsByBudgetId(
      int id) async {
    return _queryAdapter.queryList(
        'Select * from transaction_with_category WHERE budgetId = ?1',
        mapper: (Map<String, Object?> row) => TransactionWithCategoryModel(
            id: row['id'] as int?,
            categoryId: row['categoryId'] as int,
            categoryName: row['categoryName'] as String,
            isIncome: (row['isIncome'] as int) != 0,
            budgetId: row['budgetId'] as int,
            description: row['description'] as String,
            amount: row['amount'] as double,
            date: _dateTimeConverter.decode(row['date'] as int)),
        arguments: [id]);
  }

  @override
  Future<int> insertTransaction(TransactionModel transaction) {
    return _transactionModelInsertionAdapter.insertAndReturnId(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateTransaction(TransactionModel transaction) {
    return _transactionModelUpdateAdapter.updateAndReturnChangedRows(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteTransaction(TransactionModel transaction) {
    return _transactionModelDeletionAdapter
        .deleteAndReturnChangedRows(transaction);
  }

  @override
  Future<int> deleteTransactions(List<TransactionModel> transactions) {
    return _transactionModelDeletionAdapter
        .deleteListAndReturnChangedRows(transactions);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryModelInsertionAdapter = InsertionAdapter(
            database,
            'category',
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isIncome': item.isIncome ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryModel> _categoryModelInsertionAdapter;

  @override
  Future<List<CategoryModel>> getCategories() async {
    return _queryAdapter.queryList('Select * from category',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            isIncome: (row['isIncome'] as int) != 0));
  }

  @override
  Future<int> insertCategory(CategoryModel category) {
    return _categoryModelInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
