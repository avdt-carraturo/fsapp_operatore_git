import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/mock_auth_service.dart';

class OperatorHomePageApp extends StatelessWidget {
  const OperatorHomePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operatore App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        authService: MockAuthService(),
      ),
    );
  }
}
