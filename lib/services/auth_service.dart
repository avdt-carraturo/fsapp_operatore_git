// Simple in-memory auth service (plain Dart) — replace with Firebase later.
import 'dart:async';

class UserModel {
  final String id;
  final String email;

  const UserModel({required this.id, required this.email});
}

class AuthService {
  // costruttore const per poter usare const AuthService() se vuoi
  const AuthService();

  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController =
      StreamController<UserModel?>.broadcast();

  // Stream per ascoltare cambiamenti di "autenticazione"
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  // Restituisce l'utente corrente (o null)
  UserModel? get currentUser => _currentUser;

  // Simula login: accetta qualunque email/password non vuoti.
  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate latency
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email o password vuota');
    }
    _currentUser = UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), email: email);
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  // Simula logout
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _authStateController.add(null);
  }

  // Chiudi controller (se necessario)
  void dispose() {
    _authStateController.close();
  }
}
