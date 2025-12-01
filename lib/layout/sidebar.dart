// lib/layout/sidebar.dart
import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final MockUser? currentUser;

  const Sidebar({super.key, required this.selectedIndex, required this.onSelect, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFFD6001C),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Operatore XYZ",
                    style: TextStyle(color: Color(0xFFD6001C), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _navButton(context, Icons.dashboard, "Dashboard", 0),
              _navButton(context, Icons.search, "Ricerca Segnalazioni", 1),
              _navButton(context, Icons.history, "Storico Segnalazioni", 2),
            ],
          ),
          Column(
            children: const [
              Text("TRAVEL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              Text("with", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text("SECURITY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
            ],
          )
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, String label, int idx) {
    final active = idx == selectedIndex;
    return GestureDetector(
      onTap: () => onSelect(idx),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
        ]),
      ),
    );
  }
}
