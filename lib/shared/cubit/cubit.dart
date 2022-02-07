import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/module/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/module/done_tasks/done_tasks_screen.dart';
import 'package:todo/module/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeScreen(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBar());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE task(id INTEGER PRIMARY KEY , name TEXT , date TEXT , time TEXT , status TEXT)')
          .then((value) {
        print("Database is Created");
      }).catchError((error) {
        print("Error in creation of db  =${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print("Database is Opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
      print("Database is created");
    });
  }

  insertToDatabase({
    @required String name,
    @required String date,
    @required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO task(name , date , time , status) VALUES("$name","$date","$time","new")')
          .then((value) {
        print("$value task inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("Error = ${error.toString()}");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
      print(value);
    });
  }

  void updateDatabase({
    @required String status,
    @required int id,
  }) async {
    await database
        .rawUpdate('UPDATE task SET status = ? WHERE id = ?', [status, id]);
    getDataFromDatabase(database);
    emit(AppUpdateDatabaseState());
  }

  void deleteDatabase({
    @required int id,
  }) async {
    await database.rawDelete('DELETE FROM task WHERE id = ?', [id]);
    getDataFromDatabase(database);
    emit(AppDeleteDatabaseState());
  }

  void changeBottomSheet({
    @required bool isShow,
    @required IconData icon,
  }) {
    fabIcon = icon;
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetState());
  }
}
