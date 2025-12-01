// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/stat_card.dart';
import '../widgets/last_report_table.dart';
import 'package:fsapp_shared/services/notification_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  final AppState appState;
  const DashboardPage({super.key, required this.appState});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
final NotificheService _notificheService = NotificheService();
  StreamSubscription? _segnalazioniSub;

  @override
  void initState() {
    super.initState();
    _listenSegnalazioni();
  }

  @override
  void dispose() {
    _segnalazioniSub?.cancel();
    super.dispose();
  }

  void _listenSegnalazioni() {
  _segnalazioniSub = FirebaseFirestore.instance
      .collection("segnalazioni")
      .snapshots()
      .listen((snapshot) {
    for (var docChange in snapshot.docChanges) {
      if (docChange.type == DocumentChangeType.added || 
          docChange.type == DocumentChangeType.modified) {

        // Converto il documento principale in Map Dart
        final rawData = docChange.doc.data();
        if (rawData == null) continue;

        final data = Map<String, dynamic>.from(rawData as Map);

        // Converto "treno" -> "value" in Map Dart
        final trenoMap = data["treno"] != null && data["treno"]["value"] != null
            ? Map<String, dynamic>.from(data["treno"]["value"] as Map)
            : null;

        final titolo = trenoMap?["codice"] ?? "Nuova segnalazione";
        final descrizione = data["tipo"] ?? "Clicca per aprire";

        _notificheService.showNotification(
          title: titolo,
          body: descrizione,
        );
      }
    }
  });
}


  
  void _openReport(Report r) {
    widget.appState.addLog('Apertura dettaglio ${r.id}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Dettaglio ${r.id}'),
        content: Text('${r.type}\nTreno: ${r.train}\nUtente: ${r.user}\nStato: ${r.status}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Chiudi'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final state = widget.appState;
  final user = widget.appState.currentUser;
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 40),
          child: Column(
            children: [
              Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.nominativo ?? '--', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(state.currentUser?.area ?? '--', style: const TextStyle(color: Colors.black54)),
                        ],
                      )
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => state.startCall(state.currentUser?.nominativo ?? 'Personale')),
                  icon: const Icon(Icons.phone),
                  label: const Text('Contatta Personale'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (state.alertActive) {
                      state.closeAlert();
                    }
                    setState(() {});
                  },
                  child: const Text('Chiudi Segnalazione'),
                )
              ],
            ),
            const SizedBox(height: 18),

            // Grid top stats and log
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left big column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Stats row
                      Row(
                        children: [
                          Expanded(child: StatCard(title: 'Segnalazioni \naperte', value: '${state.reports.where((r) => r.status.contains('APERTA')).length}', icon: Icons.report_problem, color: Colors.green)),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(title: 'Segnalazioni \nchiuse', value: '${state.reports.where((r) => r.status.contains('CONCLUSA') || r.status.contains('Risolta')).length}', icon: Icons.check_circle, color: Colors.red)),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(title: 'Segnalazioni \npending', value: '${state.reports.where((r) => r.status.contains('IN CORSO')).length}', icon: Icons.access_time, color: Colors.orange)),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(title: 'Tempo medio \nrisposta', value: '12 min', icon: Icons.access_time, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Localizzazione + Map / Seat layout
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Localizzazione', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // carozza / seat
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Layout Treno (Carrozza)', style: TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            Text('Carrozza --', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 6,
                                              runSpacing: 6,
                                              children: List.generate(12, (i) {
                                                final idx = i + 1;
                                                final isAlertSeat = i == 0 && widget.appState.alertActive;
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: isAlertSeat ? Colors.red : (i % 3 == 0 ? Colors.green[50] : Colors.grey[100]),
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: isAlertSeat ? Colors.red.shade700 : Colors.grey.shade300),
                                                  ),
                                                  child: Text(isAlertSeat ? 'A$idx' : '$idx${['A','B','C','D'][i%4]}', style: TextStyle(fontWeight: isAlertSeat ? FontWeight.bold : FontWeight.w600)),
                                                );
                                              }),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text('Posto evidenziato in rosso.', style: TextStyle(fontSize: 12, color: Colors.black54))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Map simulation
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Mappa Linea (Simulazione)', style: TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 220,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: Colors.grey[50]),
                                        child: Stack(
                                          children: [
                                            Positioned.fill(child: Center(child: Text('Mappa (simulazione)', style: TextStyle(color: Colors.grey[400])))),
                                            if (widget.appState.alertActive)
                                              Positioned(left: 120, top: 80, child: Column(
                                                children: [
                                                  Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), shape: BoxShape.circle)),
                                                  const SizedBox(height: 6),
                                                  Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                                                ],
                                              ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Recent reports list
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Risultati (Simulazione)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            LastReportsTable(reports: widget.appState.reports, onOpen: _openReport),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Personale attestato
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Personale Attestato', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(state.currentUser?.nominativo ?? '--', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(state.currentUser?.area ?? '--', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: () => setState(() => state.startCall(state.currentUser?.nominativo ?? 'Personale')), child: const Text('Contatta Personale'))
                        ]),
                      ),

                      const SizedBox(height: 12),

                      // Posizione a bordo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Posizione a Bordo', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('--', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text('--', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: () {
                            widget.appState.addLog('Apertura piantina carrozza');
                            showDialog(context: context, builder: (_) => AlertDialog(
                              title: const Text('Piantina'),
                              content: const Text('Piantina carrozza (simulazione)'),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Chiudi'))],
                            ));
                          }, child: const Text('Visualizza Piantina'))
                        ]),
                      ),

                      const SizedBox(height: 12),

                      // Chiudi intervento
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Chiusura Intervento', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Concludi l\'alert solo a risoluzione avvenuta.'),
                          const SizedBox(height: 12),
                          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () {
                            if (!state.alertActive) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nessun alert attivo')));
                              return;
                            }
                            state.closeAlert();
                            setState(() {});
                          }, child: const Text('Chiudi Segnalazione'))
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
