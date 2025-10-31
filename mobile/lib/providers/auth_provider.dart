import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    
    // Check if user is already logged in
    if (_apiService.isAuthenticated) {
      try {
        final response = await _apiService.getProfile();
        if (response.success && response.data != null) {
          _user = response.data;
        } else {
          // Token might be invalid, clear it
          await _apiService.clearAuthData();
        }
      } catch (e) {
        // Error getting profile, clear auth data
        await _apiService.clearAuthData();
      }
    }
    
    _isInitialized = true;
    _setLoading(false);
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    
    try {
      final response = await _apiService.login(email, password);
      
      if (response.success && response.data != null) {
        _user = response.data!.user;
        notifyListeners();
        return null; // Success
      } else {
        return response.error ?? 'Login failed';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signup(String name, String email, String password) async {
    _setLoading(true);
    
    try {
      final response = await _apiService.signup(name, email, password);
      
      if (response.success && response.data != null) {
        _user = response.data!.user;
        notifyListeners();
        return null; // Success
      } else {
        return response.error ?? 'Signup failed';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    await _apiService.clearAuthData();
    _user = null;
    
    _setLoading(false);
    notifyListeners();
  }

  Future<String?> updateProfile() async {
    if (!isAuthenticated) return 'Not authenticated';
    
    try {
      final response = await _apiService.getProfile();
      
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
        return null; // Success
      } else {
        return response.error ?? 'Failed to update profile';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
}