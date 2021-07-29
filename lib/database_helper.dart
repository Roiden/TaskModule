import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_module/task_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = 'task_table';
  String colId = 'id';
  String colProjectName = 'projectName';
  String colTaskName = 'taskName';
  String colResource = 'resource';
  String colStartDate = 'startDate';
  String colDuration = 'duration';
  String colStatus = 'status';
  String colComplete = 'complete';

  // task tables
  // Id | ProjectName | TaskName | StartDate | duration | Status | Complete
  //  0       ''           ''         ''          ''        ''        ''
  //  1       ''           ''         ''          ''        ''        ''
  //  2       ''           ''         ''          ''        ''        ''
  //  3       ''           ''         ''          ''        ''        ''

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colProjectName TEXT, $colTaskName TEXT, $colResource TEXT, $colStartDate TEXT, $colDuration TEXT, $colStatus TEXT, $colComplete INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.startDate.compareTo(taskB.startDate));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
    await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}