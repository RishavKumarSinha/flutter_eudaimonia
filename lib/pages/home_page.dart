import 'package:flutter/material.dart';
import 'package:eudaimonia/components/my_drawer.dart';
import 'package:eudaimonia/components/my_habit_tile.dart';
import 'package:eudaimonia/components/my_heat_map.dart';
import 'package:eudaimonia/database/habit_database.dart';
import 'package:eudaimonia/models/habit.dart';
import 'package:eudaimonia/theme/dark_mode.dart';
import 'package:eudaimonia/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:eudaimonia/util/habit_util.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){

    //read existing habits on app startup
    Provider.of<HabitDatabase>(context,listen: false).readHabits();
    super.initState();
  
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  //create new habit
  void createNewHabit(){
    showDialog(
    context:context ,
     builder:(context)=> AlertDialog(
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: "Create a new habit",
        ),
      ),
      actions: [
        //save button
        MaterialButton(onPressed: (){
          //get the habit name
          String newHabitName = textController.text;

          //save to db
          context.read<HabitDatabase>().addHabit(newHabitName);

          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text(style:TextStyle(color: Colors.blue),'Save'),
        ),

        //cancel button
        MaterialButton(onPressed: (){
          //pop the box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text('Cancel'),
        )
      ],
     ),);
  }


//check habit is on or off
void checkHabitOnOff(bool? value,Habit habit){
  //update habit completion status
  if(value != null){
    context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
  }
}

//edit habit
void editHabitBox(Habit habit){
  //set the controller's text to the habit's current name
  textController.text=habit.name;
  showDialog(context: context, builder: (context)=>AlertDialog(
    content: TextField(controller: textController,
    ),
    actions: [
      //save
           MaterialButton(onPressed: (){
          //get the habit name
          String newHabitName = textController.text;

          //save to db
          context.read<HabitDatabase>().updateHabitName(habit.id,newHabitName);

          //pop box
          Navigator.pop(context);

          //clear controller
          textController.clear();
           },
           child: const Text(style:TextStyle(color: Colors.blue),'Save'),
           ),
      //cancel
         MaterialButton(onPressed: (){
          //pop the box
          Navigator.pop(context);

          //clear controller
          textController.clear();

        },
        child: const Text('Cancel'),
        ),
    ],
  ),
  );
}



//delete habit
void deleteHabitBox(Habit habit){
   showDialog(context: context, builder: (context)=> AlertDialog(
    title:const Text("Are you sure you want to delete?"),
    actions: [
      //delete
           MaterialButton(onPressed: (){
          //save to db
          context.read<HabitDatabase>().deleteHabit(habit.id);

          //pop box
          Navigator.pop(context);
           },
           child: const Text(style:TextStyle(color: Colors.red),'Delete'),
           ),
      //cancel
         MaterialButton(onPressed: (){
          //pop the box
          Navigator.pop(context);

        },
        child: const Text('Cancel'),
        ),
    ],
  ),
  );
}



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Habit Tracker"),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed:createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child:  Icon(Icons.add,color:  Provider.of<ThemeProvider>(context).themeData==darkMode ? Colors.white:Colors.black87,),
      ),
      body: ListView(
        children: [
          //HEATMAP
          _buildHeatMap(),

          //HABITLIST
          _buildHabitList(),
        ],
      ),
    );
  }

  //build heatmap
   Widget _buildHeatMap(){
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heatmap UI
    return FutureBuilder<DateTime?>(future: habitDatabase.getFirstLaunchDate(), builder: ((context, snapshot) {
      //once the data is available build the heatmap
      if(snapshot.hasData){
        return MyHeatMap(
          startDate: snapshot.data!,
         datasets: prepHeatMapDataset(currentHabits),
         );
      }
      //handle case where no data is returned
      else{
        return Container();
      }
    }));

   }


  //build habit list
  Widget _buildHabitList(){
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();
    
    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics:const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
      //get each individual habit
      final habit=currentHabits[index];

      //check if the habit is completed today
      bool isCompletedToday = isHabitsCompletedToday(habit.completedDays);

      //return habit tile UI
      return MyHabitTile(text: habit.name, isCompleted: isCompletedToday,
      onChanged: (value)=> checkHabitOnOff(value,habit),
      editHabit: (context) => editHabitBox(habit) ,
      deleteHabit: (context)=>deleteHabitBox(habit),
      );
    }));

  }
}