import 'package:flutter/material.dart';
import '../state/app_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.appState});
  final AppState appState;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Filtri
  final TextEditingController codiceCtrl = TextEditingController();
  final TextEditingController carrozzaCtrl = TextEditingController();
  final TextEditingController tipologiaCtrl = TextEditingController();
  final TextEditingController apertaDaCtrl = TextEditingController();
  String? statoSelezionato;

  // Mock: risultati ricerca
  List<Map<String, dynamic>> results = [];
  final List<Map<String, dynamic>> allSegnalazioni = [
  {
    "codice": "AV4030",
    "carrozza": "12",
    "data": "2025-11-10 14:22",
    "apertaDa": "Mario Rossi",
    "tipologia": "Furto",
    "stato": "APERTA",
  },
  {
    "codice": "RE7894",
    "carrozza": "7",
    "data": "2025-11-10 14:55",
    "apertaDa": "Luigi Bianchi",
    "tipologia": "Emergenza silenziosa",
    "stato": "CONCLUSA CON INTERVENTO",
  },
  {
    "codice": "AV8888",
    "carrozza": "3",
    "data": "2025-12-01 09:10",
    "apertaDa": "Paolo Verdi",
    "tipologia": "Molestia personale",
    "stato": "IN CORSO",
  }
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ----------------------------------------------------
            ///   BARRA FILTRI
            /// ----------------------------------------------------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Filtri di Ricerca",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _inputBox("Codice", codiceCtrl),
                        const SizedBox(width: 20),
                        _inputBox("Carrozza", carrozzaCtrl),
                        const SizedBox(width: 20),
                        _inputBox("Aperta da", apertaDaCtrl),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _inputBox("Tipologia", tipologiaCtrl),
                        const SizedBox(width: 20),

                        /// Dropdown stato
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Stato", style: TextStyle(fontSize: 14)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: statoSelezionato,
                                    hint: const Text("Seleziona stato"),
                                    items: const [
                                      DropdownMenuItem(value: "APERTA", child: Text("Aperta")),
                                      DropdownMenuItem(value: "IN CORSO", child: Text("In corso")),
                                      DropdownMenuItem(value: "CONCLUSA CON INTERVENTO", child: Text("Chiusa")),
                                    ],
                                    onChanged: (value) {
                                      setState(() => statoSelezionato = value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        /// Bottone Cerca
                        Row(
                          children: [
                            /// Pulsante Cerca
                            ElevatedButton(
                              onPressed: _performSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD6001C),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                              child: const Text("Cerca", style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),

                            const SizedBox(width: 16),

                            /// Pulsante Reset
                            OutlinedButton(
                              onPressed: _resetFilters,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                side: const BorderSide(color: Color(0xFFD6001C)),
                              ),
                              child: const Text("Reset", style: TextStyle(fontSize: 16, color: Color(0xFFD6001C))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ----------------------------------------------------
            ///   TABELLA RISULTATI
            /// ----------------------------------------------------
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                      columns: const [
                        DataColumn(label: Text("CODICE")),
                        DataColumn(label: Text("CARROZZA")),
                        DataColumn(label: Text("DATA/ORA APERTURA")),
                        DataColumn(label: Text("APERTA DA")),
                        DataColumn(label: Text("TIPOLOGIA")),
                        DataColumn(label: Text("STATO")),
                      ],
                      rows: results
                          .map(
                            (r) => DataRow(cells: [
                              DataCell(Text(r["codice"])),
                              DataCell(Text(r["carrozza"])),
                              DataCell(Text(r["data"])),
                              DataCell(Text(r["apertaDa"])),
                              DataCell(Text(r["tipologia"])),
                              DataCell(_buildStatoChip(r["stato"])),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  ///   FUNZIONI DI SUPPORTO
  /// ----------------------------------------------------------

void _resetFilters() {
  setState(() {
    codiceCtrl.clear();
    carrozzaCtrl.clear();
    tipologiaCtrl.clear();
    apertaDaCtrl.clear();
    statoSelezionato = null;

    // Mostra tutte le segnalazioni
    results = List.from(allSegnalazioni);
  });
}


  Widget _inputBox(String label, TextEditingController ctrl) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatoChip(String stato) {
    Color color;
     if (stato.contains("APERTA")) {
    color = Colors.red.shade400;
    } 
    else if (stato.contains("IN CORSO")) {
      color = Colors.orange.shade600;
    } 
    else if (stato.contains("CONCLUSA")) {
      color = Colors.green.shade600;
    } 
    else {
      color = Colors.grey;
    }

    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text(stato, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _performSearch() {
  setState(() {
    results = allSegnalazioni.where((s) {
    
      if (codiceCtrl.text.isNotEmpty &&
          !s["codice"].toString().toLowerCase().contains(codiceCtrl.text.toLowerCase())) {
        return false;
      }

      if (carrozzaCtrl.text.isNotEmpty &&
          !s["carrozza"].toString().toLowerCase().contains(carrozzaCtrl.text.toLowerCase())) {
        return false;
      }

      if (apertaDaCtrl.text.isNotEmpty &&
          !s["apertaDa"].toString().toLowerCase().contains(apertaDaCtrl.text.toLowerCase())) {
        return false;
      }

      if (tipologiaCtrl.text.isNotEmpty &&
          !s["tipologia"].toString().toLowerCase().contains(tipologiaCtrl.text.toLowerCase())) {
        return false;
      }

      if (statoSelezionato != null && statoSelezionato!.isNotEmpty) {
        if (!s["stato"].toString().contains(statoSelezionato!)) {
          return false;
        }
      }

      return true; 
    }).toList();
  });
}

}
