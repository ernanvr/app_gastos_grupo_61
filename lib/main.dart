import 'package:app_gastos_grupo_61/service_locator.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/category_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/transaction_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await sl.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<BudgetCubit>()),
        BlocProvider(create: (context) => sl<TransactionCubit>()),
        BlocProvider(create: (context) => sl<CategoryCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
