import 'package:flutter/material.dart';
import '../db/login_sql.dart';

class AdminPreguntasScreen extends StatefulWidget {
  @override
  _AdminPreguntasScreenState createState() => _AdminPreguntasScreenState();
}

class _AdminPreguntasScreenState extends State<AdminPreguntasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();

  List<Map<String, dynamic>> adminQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadAdminQuestions();
  }

  Future<void> _loadAdminQuestions() async {
    final preguntas = await DatabaseHelper().getAdminQuestions();
    setState(() {
      adminQuestions = preguntas;
    });
  }

  Future<void> _agregarPregunta() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().insertQuestion(
        question: _questionController.text,
        option1: _option1Controller.text,
        option2: _option2Controller.text,
        option3: _option3Controller.text,
        correctAnswer: _correctAnswerController.text,
      );

      _questionController.clear();
      _option1Controller.clear();
      _option2Controller.clear();
      _option3Controller.clear();
      _correctAnswerController.clear();

      await _loadAdminQuestions();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pregunta agregada correctamente')),
      );
    }
  }

  Future<void> _eliminarPregunta(int id) async {
    await DatabaseHelper().deleteQuestionIfAdmin(id);
    await _loadAdminQuestions();
  }

  Future<void> _reiniciarBaseDeDatos() async {
    await DatabaseHelper().resetDatabase();
    await _loadAdminQuestions();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Base de datos reiniciada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Administrador de Preguntas'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar BD',
            onPressed: _reiniciarBaseDeDatos,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agregar Pregunta',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(_questionController, 'Pregunta'),
                  _buildInput(_option1Controller, 'Opción 1'),
                  _buildInput(_option2Controller, 'Opción 2'),
                  _buildInput(_option3Controller, 'Opción 3'),
                  _buildInput(_correctAnswerController, 'Respuesta Correcta'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _agregarPregunta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text('Agregar Pregunta'),
                  ),
                ],
              ),
            ),
            const Divider(height: 40, color: Colors.white38),
            const Text(
              'Preguntas Agregadas por Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ...adminQuestions.map((pregunta) {
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    pregunta['question'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Correcta: ${pregunta['correctAnswer']}',
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminarPregunta(pregunta['id']),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pinkAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }
}
