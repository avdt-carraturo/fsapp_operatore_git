// lib/layout/top_toast.dart
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class TopToast extends StatelessWidget {
  final AppState appState;
  const TopToast({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 18,
      right: 18,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: appState.calling ? 1 : 0,
        child: appState.calling
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: const [
                    Icon(Icons.phone, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Chiamata in corso", style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
