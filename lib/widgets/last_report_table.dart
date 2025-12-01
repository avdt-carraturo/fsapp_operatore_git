// lib/widgets/last_reports_table.dart
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class LastReportsTable extends StatelessWidget {
  final List<Report> reports;
  final ValueChanged<Report>? onOpen;

  const LastReportsTable({super.key, required this.reports, this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reports.map((r) {
        Color borderColor = r.severity == 'red' ? Colors.red : (r.severity == 'orange' ? Colors.orange : Colors.green);
        return GestureDetector(
          onTap: () => onOpen?.call(r),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: borderColor, width: 6)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${r.id} - Treno: ${r.train}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${r.type} | Utente: ${r.user} | ${r.date}', style: const TextStyle(color: Colors.black54)),
                ])),
                Text(r.status, style: TextStyle(color: borderColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
