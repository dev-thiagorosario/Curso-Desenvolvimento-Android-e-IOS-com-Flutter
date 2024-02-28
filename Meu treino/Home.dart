import 'package:flutter/material.dart';

import 'Settings.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, Map<String, bool>> _planosDeTreinoPorDia = {
    'Seg': {},
    'Ter': {},
    'Qua': {},
    'Qui': {},
    'Sex': {},
    'Sáb': {},
    'Dom': {},
  };
  int _selectedTabIndex = 0;
  final List<String> _diasDaSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  void _addExercise(String exercise) {
    setState(() {
      _planosDeTreinoPorDia[_diasDaSemana[_selectedTabIndex]]?[exercise] = false;
    });
  }

  void _toggleExercise(String dia, String exercise) {
    setState(() {
      var completed = _planosDeTreinoPorDia[dia]?[exercise] ?? false;
      _planosDeTreinoPorDia[dia]?[exercise] = !completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aplicativo de Treino'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: _diasDaSemana
                .map((dia) => Tab(text: dia, icon: Icon(Icons.calendar_today)))
                .toList(),
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: _diasDaSemana.map((dia) => _buildDayPlan(dia)).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () => _showAddExerciseDialog(),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(onPressed: () {}, icon: Icon(Icons.home)),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings(planosDeTreinoPorDia: _planosDeTreinoPorDia)),
                ),
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayPlan(String dia) {
    var exercises = _planosDeTreinoPorDia[dia];
    if (exercises == null || exercises.isEmpty) {
      return Center(child: Text('Nenhum exercício para este dia.'));
    }
    return ListView(
      children: exercises.keys.map((exercise) {
        return CheckboxListTile(
          title: Text(exercise),
          value: exercises[exercise],
          onChanged: (bool? newValue) {
            if (newValue != null) {
              _toggleExercise(dia, exercise);
            }
          },
        );
      }).toList(),
    );
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newExercise = "";
        return AlertDialog(
          title: Text("Adicionar Exercício"),
          content: TextField(
            onChanged: (text) => newExercise = text,
            decoration: InputDecoration(labelText: "Digite o exercício"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Adicionar"),
              onPressed: () {
                if (newExercise.isNotEmpty) {
                  _addExercise(newExercise);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
