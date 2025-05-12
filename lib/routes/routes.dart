import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/home_screen.dart';
import '../views/characters/all_characters_screen.dart';
import '../views/characters/students_screen.dart';
import '../views/characters/staff_screen.dart';
import '../views/characters/house_characters_screen.dart';
import '../views/characters/character_detail_screen.dart';
import '../views/spells/spells_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String allCharacters = '/characters';
  static const String students = '/students';
  static const String staff = '/staff';
  static const String houseCharacters = '/house-characters';
  static const String characterDetail = '/character-detail';
  static const String spells = '/spells';

  // Route map
  static Map<String, Widget Function(BuildContext)> get routes => {
        splash: (context) => SplashScreen(),
        login: (context) => LoginScreen(),
        home: (context) => HomeScreen(),
        allCharacters: (context) => AllCharactersScreen(),
        students: (context) => StudentsScreen(),
        staff: (context) => StaffScreen(),
        houseCharacters: (context) => HouseCharactersScreen(),
        characterDetail: (context) => CharacterDetailScreen(),
        spells: (context) => SpellsScreen(),
      };
}