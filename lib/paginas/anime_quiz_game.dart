import 'package:flutter/material.dart';
import 'dart:async';
import '../db/login_sql.dart';

class AnimeQuizGame extends StatefulWidget {
  @override
  _AnimeQuizGameState createState() => _AnimeQuizGameState();
}

class _AnimeQuizGameState extends State<AnimeQuizGame> {
  late List<Map<String, dynamic>> questions; // Lista de preguntas
  int currentQuestionIndex = 0; // Índice de la pregunta actual
  int score = 0; // Puntaje actual
  int wrongAnswers = 0; // Respuestas incorrectas
  int timeLeft = 60; // Tiempo de juego (60 segundos)
  late Timer timer; // Temporizador para contar el tiempo

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Cargar las preguntas desde la base de datos
    _startTimer(); // Iniciar el temporizador
  }

  // Función para cargar las preguntas de la base de datos
  Future<void> _loadQuestions() async {
    final dbHelper = DatabaseHelper();
    final loadedQuestions = await dbHelper.getAllQuestions();
    setState(() {
      questions = loadedQuestions;
    });
  }

  // Función para iniciar el temporizador
  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame(); // Finalizar el juego cuando el tiempo se agote
      }
    });
  }

  // Función para responder a una pregunta
  void _answerQuestion(String answer) {
    if (questions[currentQuestionIndex]['correctAnswer'] == answer) {
      score++; // Incrementar el puntaje si la respuesta es correcta
    } else {
      wrongAnswers++; // Incrementar las respuestas incorrectas
    }

    if (wrongAnswers == 3 || timeLeft == 0) {
      _endGame(); // Terminar el juego si hay 3 respuestas incorrectas o se acaba el tiempo
    } else {
      setState(() {
        currentQuestionIndex++; // Avanzar a la siguiente pregunta
        if (currentQuestionIndex >= questions.length) {
          currentQuestionIndex = 0; // Reiniciar las preguntas si ya no hay más
        }
      });
    }
  }

  // Función para finalizar el juego
  void _endGame() {
    timer.cancel(); // Detener el temporizador
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Juego Terminado'),
          content: Text('Tu puntaje es $score y tu tiempo es ${60 - timeLeft} segundos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartGame(); // Reiniciar el juego
              },
              child: Text('Volver a Jugar'),
            ),
          ],
        );
      },
    );
  }

  // Función para reiniciar el juego
  void _restartGame() {
    setState(() {
      score = 0;
      wrongAnswers = 0;
      timeLeft = 60;
      currentQuestionIndex = 0;
    });
    _startTimer(); // Iniciar de nuevo el temporizador
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Espera a que las preguntas se carguen
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Preguntas de Anime'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar puntaje actual
            Text('Puntaje: $score', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),

            // Mostrar tiempo restante
            Text('Tiempo: $timeLeft', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            // Mostrar la pregunta actual
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Mostrar las opciones de respuesta
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option1']),
              child: Text(currentQuestion['option1']),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option2']),
              child: Text(currentQuestion['option2']),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option3']),
              child: Text(currentQuestion['option3']),
            ),
          ],
        ),
      ),
    );
  }
}
