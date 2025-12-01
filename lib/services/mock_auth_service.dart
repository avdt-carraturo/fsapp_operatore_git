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
      email: "mattina@email.it",
      password: "123",
      nominativo: "Reperibile Mattina",
      area: "PT Campania",
    ),
    MockUser(
      email: "pomeriggio@email.it",
      password: "123",
      nominativo: "Reperibile pomeriggio",
      area: "PT Lazio",
    ),
    MockUser(
      email: "sera@email.it",
      password: "123",
      nominativo: "Reperibile sera",
      area: "PT Liguria",
    )
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
