import 'package:flutter/material.dart';
import 'dart:async';
import '../db/login_sql.dart';

class AnimeQuizGame extends StatefulWidget {
  @override
  _AnimeQuizGameState createState() => _AnimeQuizGameState();
}

class _AnimeQuizGameState extends State<AnimeQuizGame> {
  List<Map<String, dynamic>> questions = []; // Inicializado como lista vacía
  bool _isLoading = true; // Indicador de carga
  int currentQuestionIndex = 0;
  int score = 0;
  int wrongAnswers = 0;
  int timeLeft = 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
  try {
    final dbHelper = DatabaseHelper();
    final loadedQuestions = await dbHelper.getAllQuestions();

    print("Preguntas encontradas: ${loadedQuestions.length}");

    setState(() {
      questions = loadedQuestions;
      _isLoading = false;
    });
  } catch (e) {
    print("Error al cargar preguntas: $e");

    setState(() {
      questions = [];
      _isLoading = false;
    });
  }
}



  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _answerQuestion(String answer) {
    if (questions[currentQuestionIndex]['correctAnswer'] == answer) {
      score++;
    } else {
      wrongAnswers++;
    }

    if (wrongAnswers == 3 || timeLeft == 0) {
      _endGame();
    } else {
      setState(() {
        currentQuestionIndex++;
        if (currentQuestionIndex >= questions.length) {
          currentQuestionIndex = 0;
        }
      });
    }
  }

  void _endGame() {
    timer.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Juego Terminado'),
          content: Text('Tu puntaje es $score y tu tiempo fue ${60 - timeLeft} segundos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartGame();
              },
              child: Text('Volver a Jugar'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      score = 0;
      wrongAnswers = 0;
      timeLeft = 60;
      currentQuestionIndex = 0;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: Text(
            'No hay preguntas disponibles.',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Juego de Preguntas de Anime'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Puntaje: $score', style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 10),
            Text('Tiempo restante: $timeLeft s', style: TextStyle(fontSize: 20, color: Colors.white70)),
            SizedBox(height: 30),
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option1']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(currentQuestion['option1']),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option2']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(currentQuestion['option2']),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _answerQuestion(currentQuestion['option3']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(currentQuestion['option3']),
            ),
          ],
        ),
      ),
    );
  }
}
