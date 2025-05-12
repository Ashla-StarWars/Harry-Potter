import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/character_controller.dart';
import '../../models/character.dart';
import '../../routes/routes.dart';

class StaffScreen extends StatefulWidget {
  @override
  _StaffScreenState createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch staff when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterController>(context, listen: false).fetchAllStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff de Hogwarts'),
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
                      controller.fetchAllStaff();
                    },
                    child: Text('Intentar nuevamente'),
                  ),
                ],
              ),
            );
          }

          if (controller.staff.isEmpty) {
            return Center(
              child: Text(
                'No se encontraron miembros del staff',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.staff.length,
            itemBuilder: (context, index) {
              final staffMember = controller.staff[index];
              return _buildStaffCard(context, staffMember);
            },
          );
        },
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, Character staffMember) {
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
            arguments: {'characterId': staffMember.id},
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (staffMember.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    staffMember.image,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.work, color: Colors.grey[600]),
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
                  child: Icon(Icons.work, color: Colors.grey[600]),
                ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staffMember.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (staffMember.house.isNotEmpty)
                      Text(
                        'Casa: ${staffMember.house}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getHouseColor(staffMember.house),
                        ),
                      ),
                    SizedBox(height: 4),
                    Text('Miembro del Staff de Hogwarts'),
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