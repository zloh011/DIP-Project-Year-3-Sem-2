import 'dart:async';
import 'dart:io' as io;
import 'package:dip_taskplanner/components/regExp.dart';
import 'package:dip_taskplanner/database/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dip_taskplanner/database/model/course.dart';
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
    await db.execute(
        "CREATE TABLE Course (id INTEGER PRIMARY KEY, courseid TEXT , coursename TEXT, coursevenue TEXT, stime TEXT, etime TEXT, category TEXT, week TEXT, coursetype TEXT, academicunit TEXT, name TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("Event", user.toMap());
    return res;
  }

  Future<List<User>> getAllUsers() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Event');
    List<User> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var user =
        new User(list[i]["eventname"], list[i]["eventloc"], list[i]["stime"], list[i]["etime"], list[i]["category"],list[i]["date"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    //print(employees.length);
    return employees;
  }

  Future<List<User>> getUser(String dateTime) async {
    DateTime currentDateTime = DateTime.parse(dateTime);
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Event');
    List<User> employees = new List();
    for (int i = 0; i < list.length; i++) {
      
      if(list[i]["date"]!=null){
        String value = ListOfCourses().findDateyyyyMMdd(list[i]['etime']);
        DateTime endDateTime = DateTime.parse(value);
        if(endDateTime.isAtSameMomentAs(currentDateTime)){
          var user =
            new User(list[i]["eventname"], list[i]["eventloc"], list[i]["stime"], list[i]["etime"], list[i]["category"],list[i]["date"]);
          user.setUserId(list[i]["id"]);
          employees.add(user);
        }
      }
    }
    //print(employees.length);
    return employees;
  }
  Future<List<String>> getUserCategory () async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT category FROM Event');
    List<String> employees = List();
    for (int i = 0; i<list.length; i++){
      employees.add(list[i]["category"]);
    }
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
  void deleteAllUsers() async{
    var dbClient = await db;
    dbClient.rawDelete("Delete from Event");
  }
  Future<int> saveCourse(Course course) async {
    var dbClient = await db;
    int res = await dbClient.insert("Course", course.toMap());
    return res;
  }

  Future<List<Course>> getCourse() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Course');
    List<Course> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var course =
        new Course(list[i]["courseid"],list[i]["coursename"], list[i]["coursevenue"], list[i]["stime"], list[i]["etime"], list[i]["category"],list[i]["week"],list[i]["coursetype"],list[i]["academicunit"],list[i]["name"]);
      course.setCourseId(list[i]["id"]);
      employees.add(course);
    }
    //print(employees.length);
    return employees;
  }
  Future<List<String>> getCourseid() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT courseid FROM Course');
    List<String> employees = List();
    for (int i = 0; i<list.length; i++){
      employees.add(list[i]["courseid"]);
    }
    return employees;
  }
  
  Future<int> deleteCourse(Course course) async {
    var dbClient = await db;
    int res =
        await dbClient.rawDelete('DELETE FROM Course WHERE id = ?', [course.id]);
    return res;
  }
  
  Future<bool> updateCourse(Course course) async {
    var dbClient = await db;

    int res =   await dbClient.update("Course", course.toMap(),
        where: "id = ?", whereArgs: <int>[course.id]);

    return res > 0 ? true : false;
  }
  void deleteAllCourses() async{
    var dbClient = await db;
    dbClient.rawDelete("DELETE FROM Course");
  }
  Future<bool> coursesExist() async{
    var dbClient = await db;
    var queryResult = await dbClient.rawQuery('SELECT COUNT(*) FROM Course');
    print(queryResult[0]["COUNT(*)"]);
    if(queryResult[0]["COUNT(*)"] != 0) return true;//do something if the result is not empty here
    else return false; //else return empty list
  }
  Future<bool> usersExist() async{
    var dbClient = await db;
    var queryResult = await dbClient.rawQuery('SELECT COUNT(*) FROM Event');
    print(queryResult[0]["COUNT(*)"]);
    if(queryResult[0]["COUNT(*)"] != 0) return true;//do something if the result is not empty here
    else return false; //else return empty list
  }
}
