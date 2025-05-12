import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../routes/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Harry Potter App'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1618944913860-818edec37cae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bienvenido, ${authController.username}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                'Selecciona una categoría',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCategoryCard(
                      context,
                      'Todos los personajes',
                      Icons.people,
                      AppRoutes.allCharacters,
                    ),
                    _buildCategoryCard(
                      context,
                      'Estudiantes',
                      Icons.school,
                      AppRoutes.students,
                    ),
                    _buildCategoryCard(
                      context,
                      'Staff',
                      Icons.work,
                      AppRoutes.staff,
                    ),
                    _buildCategoryCard(
                      context,
                      'Casas',
                      Icons.home,
                      AppRoutes.houseCharacters,
                      arguments: {'showHouseSelector': true},
                    ),
                    _buildCategoryCard(
                      context,
                      'Hechizos',
                      Icons.auto_fix_high,
                      AppRoutes.spells,
                    ),
                    _buildCategoryCard(
                      context,
                      'Personaje por ID',
                      Icons.person_search,
                      AppRoutes.characterDetail,
                      arguments: {'showIdInput': true},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.black.withOpacity(0.7),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: arguments);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}