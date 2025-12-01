// lib/state/app_state.dart
import '../services/mock_auth_service.dart';

class Report {
  final String id;
  final String train;
  final String type;
  final String user;
  final String date;
  final String status;
  final String severity; // 'green','orange','red'

  Report({
    required this.id,
    required this.train,
    required this.type,
    required this.user,
    required this.date,
    required this.status,
    required this.severity,
  });
}

class AppState {
  final MockAuthService authService;
  MockUser? currentUser;
  bool alertActive = false;
  bool calling = false;
  final List<String> logFeed = [];
  final List<Report> reports = [
    // some seed data
    Report(id: '#004510', train: 'AV4030', type: 'Furto', user: 'Mario Rossi', date: '2025-11-10 14:22', status: 'APERTA', severity: 'green'),
    Report(id: '#004511', train: 'RE7894', type: 'Furto', user: 'Luigi Bianchi', date: '2025-11-10 14:22', status: 'IN CORSO', severity: 'orange'),
    Report(id: '#004512', train: 'AV8888', type: 'Molestia Personale', user: 'Paolo Verdi', date: '2025-12-01 09:10', status: 'CONCLUSA CON INTERVENTO', severity: 'red'),
  ];

  AppState({required this.authService});
  void setCurrentUser(MockUser u) => currentUser = u;

  void startAlert(Map<String, String> details) {
    alertActive = true;
    addLog('Nuova segnalazione presa in carico: ${details['tipo'] ?? ' - ' }');
  }

  void closeAlert() {
    alertActive = false;
    addLog('Segnalazione chiusa.');
  }

  void startCall(String who) {
    calling = true;
    addLog('Chiamata in corso verso $who');
    Future.delayed(const Duration(seconds: 3), () {
      calling = false;
    });
  }

  void addLog(String msg) {
    final now = DateTime.now();
    logFeed.insert(0, '[${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}] $msg');
    if (logFeed.length > 20) logFeed.removeLast();
  }

  Future<bool> login(String email, String password) async {
    final user = await authService.signIn(email, password);
    if (user != null) {

      currentUser = user;
      return true;
    }
    return false;
  }
}
