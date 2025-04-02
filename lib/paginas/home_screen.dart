import 'package:flutter/material.dart';
import 'login.dart';
import 'package:inicio_registro/paginas/mapa.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final int recordScore;  // El puntaje récord
  final int recordTime;   // El récord de tiempo

  // Constructor de la clase
  const HomeScreen({
    Key? key,
    required this.name,
    required this.recordScore,
    required this.recordTime,
  }) : super(key: key);

  // Función para cerrar sesión y volver a la pantalla de login
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar el nombre del usuario
            Text(
              '¡Hola, $name!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),

            // Mostrar el récord del puntaje y el tiempo
            Text(
              'Tu récord: Puntaje: $recordScore, Tiempo: $recordTime s',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Botón para ir al mapa
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleMapScreen()), // Llamar al mapa en lugar del juego
                );
              },
              child: const Text('Ver Mapa'),
            ),
            const SizedBox(height: 20),

            // Botón para cerrar sesión
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}