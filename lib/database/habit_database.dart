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
      [HabitSchema,AppSettingsSchema],
      directory: dir.path,
    );
  }

  //save first date of the app startup
  Future<void> saveFirstLaunchDate() async{
    final existingSettings = await isar.appSettings.where().findFirst();
    if(existingSettings == null){
      final settings = AppSettings()..firstLaunchedDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }

  }

  //acces first date app
  Future<DateTime?> getFirstLaunchDate() async{
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchedDate;
  }

  


}
