class MockUser {
  final String email;
  final String password;
  final String nominativo;
  final String area;

  MockUser({
    required this.email,
    required this.password,
    required this.nominativo,
    required this.area,
  });
}

class MockAuthService {

  final List<MockUser> _users = [
    MockUser(
      email: "operatore1@polfer.it",
      password: "1234",
      nominativo: "Franco Ricciardi",
      area: "Napoli - Garibaldi - Stazione Centrale",
    ),
    MockUser(
      email: "operatore2@polfer.it",
      password: "abcd",
      nominativo: "Renato Zero",
      area: "Roma - Tiburtina - Stazione Centrale",
    ),
  ];

  Future<MockUser?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // leggero delay

    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }
  
}
