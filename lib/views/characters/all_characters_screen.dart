import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/character_controller.dart';
import '../../models/character.dart';
import '../../routes/routes.dart';

class AllCharactersScreen extends StatefulWidget {
  @override
  _AllCharactersScreenState createState() => _AllCharactersScreenState();
}

class _AllCharactersScreenState extends State<AllCharactersScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch characters when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterController>(context, listen: false).fetchAllCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos los Personajes'),
        backgroundColor: Colors.black,
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
                      controller.fetchAllCharacters();
                    },
                    child: Text('Intentar nuevamente'),
                  ),
                ],
              ),
            );
          }

          if (controller.characters.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron personajes',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.characters.length,
            itemBuilder: (context, index) {
              final character = controller.characters[index];
              return _buildCharacterCard(context, character);
            },
          );
        },
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, Character character) {
    return Card(
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
            arguments: {'characterId': character.id},
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (character.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    character.image,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
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
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (character.house.isNotEmpty)
                      Text(
                        'Casa: ${character.house}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getHouseColor(character.house),
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      character.hogwartsStudent
                          ? 'Estudiante'
                          : character.hogwartsStaff
                              ? 'Staff'
                              : character.species,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
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