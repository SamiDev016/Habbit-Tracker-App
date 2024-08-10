import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/my_drawer.dart';
import 'package:habbit_tracker/database/habit_database.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:habbit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  void creatNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "Create New Habit"),
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get new habit name
              String newHabitName = textController.text;

              //save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              //pop box
              Navigator.of(context).pop();

              //clear controller
              textController.clear();
            },
            child: const Text("Save"),
          ),

          //cancel button
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              textController.clear();
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: creatNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabit;

    return ListView.builder(
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        return ListTile(
          title: Text(habit.name),
        );
      },
    );
  }
}
