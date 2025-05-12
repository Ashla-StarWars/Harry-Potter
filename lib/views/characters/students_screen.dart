import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/character_controller.dart';
import '../../models/character.dart';
import '../../routes/routes.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch students when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterController>(context, listen: false).fetchAllStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Estudiantes de Hogwarts', 
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      body: Consumer<CharacterController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            );
          }

          if (controller.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${controller.error}',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      controller.fetchAllStudents();
                    },
                    child: Text('Intentar nuevamente'),
                  ),
                ],
              ),
            );
          }

          if (controller.students.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron estudiantes',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.students.length,
            itemBuilder: (context, index) {
              final student = controller.students[index];
              return _buildStudentCard(context, student);
            },
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Character student) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.characterDetail,
            arguments: {'characterId': student.id},
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (student.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    student.image,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.school, color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                Container(
                  height: 80,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school, color: Colors.grey[600]),
                ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (student.house.isNotEmpty)
                      Text(
                        'Casa: ${student.house}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getHouseColor(student.house),
                        ),
                      ),
                    SizedBox(height: 4),
                    Text('Estudiante de Hogwarts', 
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        )),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return Colors.red;
      case 'slytherin':
        return Colors.green;
      case 'ravenclaw':
        return Colors.blue;
      case 'hufflepuff':
        return Colors.amber[700]!;
      default:
        return Colors.grey;
    }
  }
}