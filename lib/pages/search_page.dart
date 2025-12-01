import 'package:flutter/material.dart';
import '../state/app_state.dart';

class SearchPage extends StatelessWidget {
  final AppState appState;

  const SearchPage({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Ricerca Segnalazioni (UI da implementare)", style: TextStyle(fontSize: 24)),
    );
  }
}
