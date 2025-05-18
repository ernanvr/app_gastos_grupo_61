import 'dart:developer' show log;

import 'package:app_gastos_grupo_61/src/domain/entities/budget_with_balance.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/budget_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/error_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/home_page_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/home_page_no_content_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/splash_screen.dart';
import 'package:app_gastos_grupo_61/src/presentation/pages/transaction_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
      routes: [
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) => HomePageScreen(),
          routes: [
            GoRoute(
              path: 'new-transaction',
              name: 'new-transaction',
              builder: (context, state) => TransactionScreen(transaction: null),
            ),
            GoRoute(
              path: 'update-transaction',
              name: 'update-transaction',
              builder: (context, state) {
                final extra = state.extra;

                if (extra == null || extra is! TransactionWithCategory) {
                  log(
                    'Error de ruta: La ruta /home/update-transaction requiere un objeto TransactionWithCategory como extra.',
                  );

                  return const ErrorScreen(
                    errorMessage: 'Datos de transacción inválidos para edición',
                  );
                }

                final transaction = state.extra as TransactionWithCategory?;

                return TransactionScreen(
                  transaction: transaction,
                  budgetId: transaction?.budgetId,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'home-no-content',
          name: 'home-no-content',
          builder: (context, state) => HomePageNoContentScreen(),
          routes: [
            GoRoute(
              path: 'new-budget',
              name: 'new-budget',
              builder: (context, state) => BudgetScreen(),
            ),
            GoRoute(
              path: 'update-budget',
              name: 'update-budget',
              builder: (context, state) {
                final extra = state.extra;

                if (extra == null || extra is! BudgetWithBalance) {
                  log(
                    'Error de ruta: La ruta /home/update-budget requiere un objeto BudgetWithBalance como extra.',
                  );

                  return const ErrorScreen(
                    errorMessage: 'Datos de transacción inválidos para edición',
                  );
                }

                final budget = state.extra as BudgetWithBalance?;

                return BudgetScreen(budgetToEdit: budget);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
