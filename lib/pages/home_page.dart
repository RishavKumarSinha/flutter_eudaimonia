import 'package:eudaimonia/components/my_drawer.dart';
import 'package:eudaimonia/components/my_habit_tile.dart';
import 'package:eudaimonia/database/habit_database.dart';
import 'package:eudaimonia/main.dart';
import 'package:eudaimonia/model/habit.dart';
import 'package:eudaimonia/util/habit_util.dart';
import 'package:flutter/material.dart';
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

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Create a new habit',
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      String newHabitName = textController.text;
                      context.read<HabitDatabase>().addHabit(newHabitName);
                      Navigator.pop(context);
                      textController.clear();
                    },
                    child: const Text('Save')),
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);

                      textController.clear();
                    },
                    child: const Text('Cancel'))
              ],
            ));
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if(value != null){
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Edit habit',
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      String newHabitName = textController.text;
                      context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
                      Navigator.pop(context);
                      textController.clear();
                    },
                    child: const Text('Save')),
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);

                      textController.clear();
                    },
                    child: const Text('Cancel'))
              ],
            ));
  }

  void deleteHabit(Habit habit) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete Habit'),
      content: const Text('Are you sure you want to delete this habit?'),
      actions: [
        MaterialButton(onPressed: () {
          context.read<HabitDatabase>().deleteHabit(habit.id);
          Navigator.pop(context);
        }, child: const Text('Yes')),
        MaterialButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('No'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return MyHabitTile(text: habit.name, isCompleted: isCompletedToday,onChanged: (value)=>checkHabitOnOff(value,habit),editHabit: (context)=>editHabitBox(habit),deleteHabit: (context)=>deleteHabit(habit),);
      },
    );
  }
}
