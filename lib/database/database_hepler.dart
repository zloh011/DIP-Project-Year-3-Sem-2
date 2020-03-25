import 'dart:async';
import 'dart:io' as io;
import 'package:intl/intl.dart';
import 'package:dip_taskplanner/database/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mainDB.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Event (id INTEGER PRIMARY KEY, eventname TEXT, eventloc TEXT, stime TEXT, etime TEXT, category TEXT, date TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("Event", user.toMap());
    return res;
  }

  Future<List<User>> getUser(String dateTime) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Event');
    List<User> employees = new List();
    for (int i = 0; i < list.length; i++) {
      if(list[i]["date"]!=null){
        
        if(dateTime==list[i]["date"]){
          var user =
            new User(list[i]["eventname"], list[i]["eventloc"], list[i]["stime"], list[i]["etime"], list[i]["category"],list[i]["date"]);
          user.setUserId(list[i]["id"]);
          employees.add(user);
        }
      }
    }
    print(employees.length);
    return employees;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM Event WHERE id = ?', [user.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;




    int res =   await dbClient.update("Event", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);



    return res > 0 ? true : false;
  }
}
