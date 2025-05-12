import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/spell.dart';

class HarryPotterApiService {
  final String baseUrl = 'https://hp-api.onrender.com/api';

  // Fetch all characters
  Future<List<Character>> getAllCharacters() async {
    final response = await http.get(Uri.parse('$baseUrl/characters'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  // Fetch all students
  Future<List<Character>> getAllStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/characters/students'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  // Fetch all staff
  Future<List<Character>> getAllStaff() async {
    final response = await http.get(Uri.parse('$baseUrl/characters/staff'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load staff');
    }
  }

  // Fetch characters by house
  Future<List<Character>> getCharactersByHouse(String house) async {
    final response = await http.get(Uri.parse('$baseUrl/characters/house/$house'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters from $house');
    }
  }
  
  // Fetch character by ID
  Future<Character> getCharacterById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/character/$id'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) {
        throw Exception('Character not found');
      }
      return Character.fromJson(data.first);
    } else {
      throw Exception('Failed to load character');
    }
  }
  
  // Fetch all spells
  Future<List<Spell>> getAllSpells() async {
    final response = await http.get(Uri.parse('$baseUrl/spells'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Spell.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spells');
    }
  }
}