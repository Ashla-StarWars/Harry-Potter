import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/character_controller.dart';
import '../../models/character.dart';
import '../../routes/routes.dart';

class HouseCharactersScreen extends StatefulWidget {
  @override
  _HouseCharactersScreenState createState() => _HouseCharactersScreenState();
}

class _HouseCharactersScreenState extends State<HouseCharactersScreen> {
  String? _selectedHouse;
  final List<Map<String, dynamic>> _houses = [
    {
      'name': 'Gryffindor',
      'color': Colors.red,
      'image':
          'https://static.wikia.nocookie.net/harrypotter/images/b/b1/Gryffindor_CrestR.png'
    },
    {
      'name': 'Slytherin',
      'color': Colors.green,
      'image':
          'https://static.wikia.nocookie.net/harrypotter/images/0/00/Slytherin_CrestR.png'
    },
    {
      'name': 'Ravenclaw',
      'color': Colors.blue,
      'image':
          'https://static.wikia.nocookie.net/harrypotter/images/7/71/Ravenclaw_CrestR.png'
    },
    {
      'name': 'Hufflepuff',
      'color': Colors.amber[700],
      'image':
          'https://static.wikia.nocookie.net/harrypotter/images/0/06/Hufflepuff_CrestR.png'
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final showHouseSelector = args?['showHouseSelector'] as bool? ?? true;

    if (!showHouseSelector && args != null && args.containsKey('house')) {
      _selectedHouse = args['house'] as String;
      _fetchHouseCharacters();
    }
  }

  void _fetchHouseCharacters() {
    if (_selectedHouse != null) {
      Provider.of<CharacterController>(context, listen: false)
          .fetchCharactersByHouse(_selectedHouse!);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.amber),
      title: Text(
        _selectedHouse != null
            ? 'Personajes de $_selectedHouse'
            : 'Casas de Hogwarts',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
    ),
    body: _selectedHouse == null
        ? _buildHouseSelection()
        : _buildCharactersList(),
  );
}

Widget _buildHouseSelection() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
            'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80'),
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
            'Selecciona una casa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _houses.length,
              itemBuilder: (context, index) {
                final house = _houses[index];
                return _buildHouseCard(house);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildHouseCard(Map<String, dynamic> house) {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: house['color'],
        width: 2,
      ),
    ),
    child: InkWell(
      onTap: () {
        setState(() {
          _selectedHouse = house['name'];
        });
        _fetchHouseCharacters();
      },
      borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (house['name'] == 'Gryffindor') {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/gryffindor.png',
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else if (house['name'] == 'Slytherin') {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/slytherin.png',
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else if (house['name'] == 'Ravenclaw') {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/ravenclaw.png',
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else if (house['name'] == 'Hufflepuff') {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/hufflepuff.png',
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        house['image'],
                        fit: BoxFit.fitHeight,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
    ),
  );
}

  Widget _buildCharactersList() {
    return Consumer<CharacterController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _getHouseColor(_selectedHouse ?? ''),
              ),
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
                    backgroundColor: _getHouseColor(_selectedHouse ?? ''),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _fetchHouseCharacters,
                  child: Text('Intentar nuevamente'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedHouse = null;
                    });
                  },
                  child: Text('Volver a selección de casas'),
                ),
              ],
            ),
          );
        }

        if (controller.houseCharacters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'No se encontraron personajes en esta casa',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedHouse = null;
                    });
                  },
                  child: Text('Volver a selección de casas'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              itemCount: controller.houseCharacters.length,
              itemBuilder: (context, index) {
                final character = controller.houseCharacters[index];
                return _buildCharacterCard(context, character);
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back),
                  label: Text('Cambiar casa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getHouseColor(_selectedHouse ?? ''),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedHouse = null;
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCharacterCard(BuildContext context, Character character) {
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Casa: $_selectedHouse',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _getHouseColor(_selectedHouse ?? ''),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      character.hogwartsStudent
                          ? 'Estudiante'
                          : character.hogwartsStaff
                              ? 'Staff'
                              : character.species,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
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
