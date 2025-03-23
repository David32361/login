import 'package:flutter/material.dart';
import '../db/login_sql.dart';
import 'login.dart';
import 'admin_preguntas.dart'; 

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<Map<String, dynamic>>> users;

  @override
  void initState() {
    super.initState();
    users = _getUsers();
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    return await DatabaseHelper().getAllUsers();
  }

  void _deleteUser(int userId) async {
    await DatabaseHelper().deleteUser(userId);
    setState(() {
      users = _getUsers();
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _goToAdminPreguntas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPreguntasScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _goToAdminPreguntas,
              icon: const Icon(Icons.quiz),
              label: const Text('Gestionar Preguntas'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Usuarios Registrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar usuarios'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay usuarios registrados'));
                }

                final userList = snapshot.data!;

                return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final user = userList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          user['username'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user['email']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user['id']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
