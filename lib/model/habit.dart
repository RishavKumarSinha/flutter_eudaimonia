import 'package:isar/isar.dart';

//run cmd to genrate file dart run build_runner build
part 'habit.g.dart';


@Collection()
class Habit {
  //Habit id
  Id id = Isar.autoIncrement;

  //Habit name
  late String name;

  //completed days
  List<DateTime> completedDays = [
    //DateTime(year,month,day)
  ];
}
