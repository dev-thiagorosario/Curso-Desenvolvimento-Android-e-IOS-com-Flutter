import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final Map<String, Map<String, bool>> planosDeTreinoPorDia;

  const Settings({super.key, required this.planosDeTreinoPorDia});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _removeExercise(String day, String exercise) {
    setState(() {
      widget.planosDeTreinoPorDia[day]?.remove(exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: widget.planosDeTreinoPorDia.keys.length,
        itemBuilder: (context, index) {
          String day = widget.planosDeTreinoPorDia.keys.elementAt(index);
          var exercises = widget.planosDeTreinoPorDia[day]!;
          return ExpansionTile(
            title: Text(day),
            children: exercises.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeExercise(day, entry.key),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
