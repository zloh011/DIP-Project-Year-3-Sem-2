import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/user.dart';

class AddUserDialog {
  final teEventName = TextEditingController();
  final teEventLocation = TextEditingController();
  final teST = TextEditingController();
  final teET = TextEditingController();
  final teCAT = TextEditingController();
  User user;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(
      BuildContext context, _myHomePageState, bool isEdit, User user,String dateTime) {
    if (user != null) {
      this.user=user;
      teEventName.text = user.eventName;
      teEventLocation.text = user.eventLocation;
      teST.text = user.eventST;
      teET.text = user.eventET;
      teCAT.text = user.eventCAT;

    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit' : 'Add new User'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Event Name", teEventName),
            getTextField("Event Location", teEventLocation),
            getTextField("Start Time:", teST),
            getTextField("End Time:", teET),
            getTextField("Category", teCAT),
            new GestureDetector(
              onTap: () {
                addRecord(isEdit,dateTime);
                _myHomePageState.displayRecord();
                Navigator.of(context).pop();
              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    isEdit?"Edit":"Add", EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future addRecord(bool isEdit,String dateTime) async {
    var db = new DatabaseHelper();
    var user = new User(teEventName.text, teEventLocation.text, teST.text, teET.text, teCAT.text,dateTime);
    if (isEdit) {
      user.setUserId(this.user.id);
      await db.update(user);
    } else {
      await db.saveUser(user);
    }
  }
}
