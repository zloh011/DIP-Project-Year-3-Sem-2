import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/user.dart';

import 'dart:async';

//import 'package:flutter/material.dart';


abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {

  HomeContract _view;

  var db = new DatabaseHelper();

  HomePresenter(this._view);


  delete(User user) {
    var db = new DatabaseHelper();
    db.deleteUsers(user);
    updateScreen();
  }

  Future<List<User>> getUser(String dateTime) {
    return db.getUser(dateTime);
  }

  Future<List<String>> getcourseid() async {
    var db = DatabaseHelper();
    return await db.getCourseid();
  }

  updateScreen() {
    _view.screenUpdate();
  }

}
