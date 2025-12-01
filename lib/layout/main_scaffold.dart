// lib/layout/main_scaffold.dart
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../layout/sidebar.dart';
import '../pages/dashboard_page.dart';
import '../pages/search_page.dart';
import '../pages/history_page.dart';
import '../layout/top_toast.dart';

class MainScaffold extends StatefulWidget {
  final AppState appState;
  const MainScaffold({super.key, required this.appState});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int selectedIndex = 0;

  void _onSelect(int i) => setState(() => selectedIndex = i);

  @override
  Widget build(BuildContext context) {
    // seleziona il contenuto della pagina
    Widget content;
    switch (selectedIndex) {
      case 0:
        content = DashboardPage(appState: widget.appState); // Dashboard legge currentUser
        break;
      case 1:
        content = SearchPage(appState: widget.appState);
        break;
      case 2:
        content = HistoryPage(appState: widget.appState);
        break;
      default:
        content = Container();
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar fissa sulla sinistra
          Sidebar(selectedIndex: selectedIndex, onSelect: _onSelect, currentUser: widget.appState.currentUser),

          // Contenuto principale con stack per TopToast
          Expanded(
            child: Stack(
              children: [
                content,
                TopToast(appState: widget.appState),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
