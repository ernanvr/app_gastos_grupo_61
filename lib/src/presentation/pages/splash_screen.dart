import 'dart:async';

import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_cubit.dart';
import 'package:app_gastos_grupo_61/src/presentation/bloc/cubit/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart' show Lottie;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after a short delay
    Timer(const Duration(seconds: 5), () {
      // Trigger the loading of budgets after the splash screen delay
      BlocProvider.of<BudgetCubit>(context).loadBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetCubit, BudgetState>(
      listener: (context, state) {
        // Navigate once budgets are loaded (either successfully or with an error)
        if (state.status == BudgetStatus.loaded ||
            state.status == BudgetStatus.error) {
          if (state.budgets.isEmpty) {
            // No budgets found, navigate to the no content home page
            GoRouter.of(context).replaceNamed('home-no-content');
          } else {
            // Budgets found, navigate to the main home page
            GoRouter.of(context).replaceNamed('home');
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(100, 63, 55, 201),
                    Color.fromARGB(100, 255, 89, 99),
                    Color.fromARGB(100, 63, 55, 200),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Lottie.asset(
                      'assets/Animation.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    'Control de Gastos Personales',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 63, 55, 201),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Elaborado por el equipo #61 de la materia de Desarrollo de Aplicaciones Móviles - ESIT.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: const Color.fromARGB(179, 36, 36, 36),
                    ),
                  ),
                ],
              ),
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.all(32.0),
            //     child: SizedBox(
            //       width: 230.0,
            //       height: 52.0,
            //       child: ElevatedButton(
            //         onPressed: () {
            //           print('¡Iniciar!');
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.deepPurpleAccent,
            //           padding: const EdgeInsets.symmetric(vertical: 16.0),
            //           textStyle: const TextStyle(fontSize: 18.0),
            //         ),
            //         child: const Text(
            //           'Iniciar',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
