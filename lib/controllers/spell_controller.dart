import 'package:flutter/material.dart';
import '../models/spell.dart';
import '../services/harry_potter_api_service.dart';

class SpellController extends ChangeNotifier {
  final HarryPotterApiService _apiService = HarryPotterApiService();
  
  List<Spell> _spells = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Spell> get spells => _spells;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Get all spells
  Future<void> fetchAllSpells() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _spells = await _apiService.getAllSpells();
    } catch (e) {
      _error = 'Failed to fetch spells: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}