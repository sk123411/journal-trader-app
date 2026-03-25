import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _client = Supabase.instance.client;

  /// ------------------ SIGN UP ------------------
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }

  /// ------------------ LOGIN ------------------
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// ------------------ LOGOUT ------------------
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  /// ------------------ CURRENT USER ------------------
  static User? get currentUser => _client.auth.currentUser;

  /// ------------------ IS LOGGED IN ------------------
  static bool get isLoggedIn => currentUser != null;

  /// ------------------ GET USER ID ------------------
  static String? get userId => currentUser?.id;

  /// ------------------ AUTH STATE LISTENER ------------------
  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;
}