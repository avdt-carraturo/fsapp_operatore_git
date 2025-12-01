import 'package:flutter/material.dart';
import '../state/app_state.dart';

class HistoryPage extends StatelessWidget {
  final AppState appState;

  const HistoryPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Storico Segnalazioni (UI da implementare)", style: TextStyle(fontSize: 24)),
    );
  }
}
