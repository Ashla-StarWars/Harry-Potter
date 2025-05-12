import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/spell_controller.dart';
import '../../models/spell.dart';

class SpellsScreen extends StatefulWidget {
  @override
  _SpellsScreenState createState() => _SpellsScreenState();
}

class _SpellsScreenState extends State<SpellsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch spells when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpellController>(context, listen: false).fetchAllSpells();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hechizos'),
        backgroundColor: Colors.black,
      ),
      body: Consumer<SpellController>(
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
                      controller.fetchAllSpells();
                    },
                    child: Text('Intentar nuevamente'),
                  ),
                ],
              ),
            );
          }

          if (controller.spells.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron hechizos',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.spells.length,
            itemBuilder: (context, index) {
              final spell = controller.spells[index];
              return _buildSpellCard(spell);
            },
          );
        },
      ),
    );
  }

  Widget _buildSpellCard(Spell spell) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_fix_high,
                  color: Colors.amber,
                ),
                SizedBox(width: 8),
                Text(
                  spell.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (spell.description.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                spell.description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}