import 'package:flutter/material.dart';
import 'package:habbit_tracker/models/app_settings.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  //save first date of the app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchedDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //acces first date app
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchedDate;
  }

  //list of habits
  final List<Habit> currentHabit = [];

  //CRUD OPERATIONS
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read from db
    readHabits();
  }

  //Read saved habist from DB
  Future<void> readHabits() async {
    //fetch all habits from DB
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);

    //update UI
    notifyListeners();
  }

  //UPDATE
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specefics habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }

        await isar.habits.put(habit);
      });
    }

    //re read from DB
    readHabits();
  }

  Future<void> updateHabitName(int id, String newName) async{
    final habit = await isar.habits.get(id);

    if(habit != null){
      await isar.writeTxn(() async{
        habit.name = newName;

        await isar.habits.put(habit);
      });
    }
    readHabits();
  }


  Future<void> deleteHabit(int id) async{
    
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });

    readHabits();
  }



}
