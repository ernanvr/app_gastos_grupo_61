import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Lottie.asset('assets/Animation.json', 
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
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: 230.0,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: () {
                    print('¡Iniciar!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}