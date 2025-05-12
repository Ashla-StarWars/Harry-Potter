import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/character_controller.dart';
import '../../models/character.dart';

class CharacterDetailScreen extends StatefulWidget {
  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final TextEditingController _idController = TextEditingController();
  String? _selectedCharacterId;
  bool _showIdInput = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _showIdInput = args?['showIdInput'] as bool? ?? false;
    
    if (args != null && args.containsKey('characterId')) {
      _selectedCharacterId = args['characterId'] as String;
      _fetchCharacter();
    }
  }

  void _fetchCharacter() {
    if (_selectedCharacterId != null) {
      Provider.of<CharacterController>(context, listen: false)
          .fetchCharacterById(_selectedCharacterId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showIdInput ? 'Buscar Personaje' : 'Detalle del Personaje'),
        backgroundColor: Colors.black,
      ),
      body: _showIdInput ? _buildSearchView() : _buildCharacterDetailView(),
    );
  }

  Widget _buildSearchView() {
    final characterController = Provider.of<CharacterController>(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ingrese el ID del personaje o selecciónelo de la lista',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'ID del personaje',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_idController.text.isNotEmpty) {
                    setState(() {
                      _selectedCharacterId = _idController.text;
                      _showIdInput = false;
                    });
                    _fetchCharacter();
                  }
                },
                child: Text('Buscar'),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'O seleccione un personaje:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: FutureBuilder(
              future: characterController.characters.isEmpty
                  ? characterController.fetchAllCharacters()
                  : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    characterController.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (characterController.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${characterController.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: characterController.characters.length,
                  itemBuilder: (context, index) {
                    final character = characterController.characters[index];
                    return ListTile(
                      leading: character.image.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(character.image),
                            )
                          : CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                      title: Text(character.name),
                      subtitle: Text(character.house.isNotEmpty
                          ? 'Casa: ${character.house}'
                          : character.species),
                      onTap: () {
                        setState(() {
                          _selectedCharacterId = character.id;
                          _showIdInput = false;
                        });
                        _fetchCharacter();
                      },
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

  Widget _buildCharacterDetailView() {
    return Consumer<CharacterController>(
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
                    setState(() {
                      _showIdInput = true;
                    });
                  },
                  child: Text('Volver a búsqueda'),
                ),
              ],
            ),
          );
        }

        final character = controller.selectedCharacter;
        if (character == null) {
          return Center(
            child: Text(
              'No se encontró información del personaje',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: character.image.isNotEmpty
                    ? Hero(
                        tag: 'character-${character.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            character.image,
                            height: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                Icon(Icons.person, size: 100, color: Colors.grey),
                          ),
                        ),
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.person, size: 100, color: Colors.grey[600]),
                      ),
              ),
              SizedBox(height: 24),
              _buildCharacterInfo(character),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterInfo(Character character) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (character.alternateNames.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'También conocido como: ${character.alternateNames.join(", ")}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
            Divider(height: 24),
            _infoRow('ID', character.id),
            _infoRow('Especie', character.species),
            _infoRow('Género', character.gender),
            _infoRow('Casa', character.house, 
              valueStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getHouseColor(character.house),
              ),
            ),
            _infoRow('Fecha de nacimiento', character.dateOfBirth),
            _infoRow('Año de nacimiento', character.yearOfBirth.toString()),
            _infoRow('¿Es mago/bruja?', character.wizard ? 'Sí' : 'No'),
            _infoRow('Linaje', character.ancestry),
            _infoRow('Color de ojos', character.eyeColour),
            _infoRow('Color de cabello', character.hairColour),
            _infoRow('Patronus', character.patronus),
            _infoRow('¿Estudiante de Hogwarts?', character.hogwartsStudent ? 'Sí' : 'No'),
            _infoRow('¿Staff de Hogwarts?', character.hogwartsStaff ? 'Sí' : 'No'),
            _infoRow('Actor', character.actor),
            if (character.alternateActors.isNotEmpty)
              _infoRow('Actores alternativos', character.alternateActors.join(", ")),
            _infoRow('¿Vivo?', character.alive ? 'Sí' : 'No'),
            
            SizedBox(height: 16),
            Text(
              'Varita',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(height: 16),
            _infoRow('Madera', character.wand.wood),
            _infoRow('Núcleo', character.wand.core),
            _infoRow('Longitud', character.wand.length?.toString() ?? 'Desconocida'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    if (value.isEmpty || value == '0' || value == 'null') return SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? TextStyle(fontSize: 16),
            ),
          ),
        ],
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

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}