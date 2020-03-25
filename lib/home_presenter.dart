import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/user.dart';

import 'dart:async';


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

  updateScreen() {
    _view.screenUpdate();

  }


}
