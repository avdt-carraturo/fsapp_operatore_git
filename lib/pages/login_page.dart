// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import '../layout/main_scaffold.dart';
import '../state/app_state.dart';

class LoginPage extends StatefulWidget {
  final MockAuthService authService;
  const LoginPage({super.key, required this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _doLogin() async {
    setState(() {
      loading = true;
      error = null;
    });

    final user = await widget.authService.signIn(
        emailCtrl.text.trim(), passCtrl.text.trim());

    if (!mounted) return;

    if (user == null) {
      setState(() {
        loading = false;
        error = "Credenziali invalide";
      });
      return;
    }

    // prepara lo stato
    final appState = AppState(authService: widget.authService);
    appState.setCurrentUser(user);

    // naviga alla main scaffold
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScaffold(appState: appState)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login", style: TextStyle(fontSize: 28)),
              const SizedBox(height: 20),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _doLogin,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Accedi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
