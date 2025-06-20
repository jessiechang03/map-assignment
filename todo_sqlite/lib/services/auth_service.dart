import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import 'database_helper.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  AuthService._init();

  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signUp(String email, String password, {String? name}) async {
    try {
      // Check if user already exists
      final existingUser = await DatabaseHelper.instance.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('User already exists with this email');
      }

      // Create new user
      final user = User(
        email: email,
        password: _hashPassword(password),
        name: name,
        createdAt: DateTime.now(),
      );

      final userId = await DatabaseHelper.instance.createUser(user);
      final createdUser = user.copyWith(id: userId);

      // Save to shared preferences
      await _saveUserSession(createdUser);

      return createdUser;
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email);
      if (user == null) {
        throw Exception('No user found with this email');
      }

      if (user.password != _hashPassword(password)) {
        throw Exception('Invalid password');
      }

      // Save to shared preferences
      await _saveUserSession(user);

      return user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    
    if (userId != null) {
      return await DatabaseHelper.instance.getUserById(userId);
    }
    
    return null;
  }

  Future<bool> isSignedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id!);
    await prefs.setString(_userEmailKey, user.email);
  }
}