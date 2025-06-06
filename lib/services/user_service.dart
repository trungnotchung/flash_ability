import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_data/profile/profile.dart';

/// A service class to manage user-related data
class UserService {
  static const String _usernameKey = 'username';
  static const String _currentUserIndexKey = 'currentUserIndex';
  static const String _profileImagePathKey = 'profileImagePath';

  static String _cachedUsername = 'Learner';
  static int _currentUserIndex = 0;
  static String? _cachedProfileImagePath;
  static bool _initialized = false;

  /// Initialize the service and load cached data
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserIndex = prefs.getInt(_currentUserIndexKey) ?? 0;
      _cachedUsername =
          prefs.getString(_usernameKey) ??
          userAccounts[_currentUserIndex]['username'] ??
          'Learner';
      _cachedProfileImagePath = prefs.getString(_profileImagePathKey);
      _initialized = true;
      debugPrint('UserService initialized successfully');
    } catch (e) {
      // Keep default values if there's an error
      debugPrint('Error initializing UserService: $e');
      // Mark as initialized even if there was an error to prevent repeated attempts
      _initialized = true;
    }
  }

  /// Get the current username
  static Future<String> getUsername() async {
    // Ignore errors during initialization to provide a seamless experience
    if (!_initialized) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Error initializing when getting username: $e');
      }
    }
    return _cachedUsername;
  }

  /// Get the current user's profile image path
  static Future<String?> getProfileImagePath() async {
    if (!_initialized) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Error initializing when getting profile image path: $e');
      }
    }
    return _cachedProfileImagePath;
  }

  /// Get the current user's full profile
  static Map<String, String> getCurrentUser() {
    return userAccounts[_currentUserIndex];
  }

  /// Update the username
  static Future<bool> setUsername(String username) async {
    if (username.isEmpty) return false;

    // Always update the cache first
    _cachedUsername = username;
    userAccounts[_currentUserIndex]['username'] = username;

    try {
      if (!_initialized) {
        await initialize();
      }

      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_usernameKey, username);
    } catch (e) {
      debugPrint('Error saving username: $e');
      // Return true since we at least updated the cache
      return true;
    }
  }

  /// Update the profile image path
  static Future<bool> setProfileImagePath(String imagePath) async {
    // Always update the cache first
    _cachedProfileImagePath = imagePath.isEmpty ? null : imagePath;

    try {
      if (!_initialized) {
        await initialize();
      }

      final prefs = await SharedPreferences.getInstance();
      if (imagePath.isEmpty) {
        return await prefs.remove(_profileImagePathKey);
      } else {
        return await prefs.setString(_profileImagePathKey, imagePath);
      }
    } catch (e) {
      debugPrint('Error saving profile image path: $e');
      // Return true since we at least updated the cache
      return true;
    }
  }

  /// Switch to a different user account
  static Future<bool> switchUser(int userIndex) async {
    if (userIndex < 0 || userIndex >= userAccounts.length) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserIndex = userIndex;
      _cachedUsername = userAccounts[userIndex]['username']!;

      // Clear the profile image when switching users
      _cachedProfileImagePath = null;

      await prefs.setInt(_currentUserIndexKey, userIndex);
      await prefs.setString(_usernameKey, _cachedUsername);
      await prefs.remove(_profileImagePathKey);
      return true;
    } catch (e) {
      debugPrint('Error switching user: $e');
      return false;
    }
  }

  /// Get all available user accounts
  static List<Map<String, String>> getAllUsers() {
    return userAccounts;
  }

  /// Clear user data and reset to default values
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usernameKey);
      await prefs.remove(_currentUserIndexKey);
      await prefs.remove(_profileImagePathKey);
      _currentUserIndex = 0;
      _cachedUsername = 'Learner';
      _cachedProfileImagePath = null;
      _initialized = false;
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
}
