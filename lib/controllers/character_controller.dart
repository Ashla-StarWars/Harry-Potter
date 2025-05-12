import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/harry_potter_api_service.dart';

class CharacterController extends ChangeNotifier {
  final HarryPotterApiService _apiService = HarryPotterApiService();
  
  List<Character> _characters = [];
  List<Character> _students = [];
  List<Character> _staff = [];
  List<Character> _houseCharacters = [];
  Character? _selectedCharacter;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Character> get characters => _characters;
  List<Character> get students => _students;
  List<Character> get staff => _staff;
  List<Character> get houseCharacters => _houseCharacters;
  Character? get selectedCharacter => _selectedCharacter;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Get all characters
  Future<void> fetchAllCharacters() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _characters = await _apiService.getAllCharacters();
    } catch (e) {
      _error = 'Failed to fetch characters: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all students
  Future<void> fetchAllStudents() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _students = await _apiService.getAllStudents();
    } catch (e) {
      _error = 'Failed to fetch students: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all staff
  Future<void> fetchAllStaff() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _staff = await _apiService.getAllStaff();
    } catch (e) {
      _error = 'Failed to fetch staff: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get characters by house
  Future<void> fetchCharactersByHouse(String house) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _houseCharacters = await _apiService.getCharactersByHouse(house);
    } catch (e) {
      _error = 'Failed to fetch house characters: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get character by ID
  Future<void> fetchCharacterById(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _selectedCharacter = await _apiService.getCharacterById(id);
    } catch (e) {
      _error = 'Failed to fetch character: ${e.toString()}';
      _selectedCharacter = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}