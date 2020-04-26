import 'dart:async';
import 'dart:io';

import 'package:dip_taskplanner/Screen/CalendarPage.dart';
import 'package:flutter/material.dart';
import 'package:dip_taskplanner/add_user_dialog.dart';
import 'package:dip_taskplanner/database/model/user.dart';
import 'package:dip_taskplanner/home_presenter.dart';
import 'package:dip_taskplanner/list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.dateTime}) : super(key: key);
  final String title;
  final String dateTime;
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements HomeContract {
  HomePresenter homePresenter;
  @override
  void initState() {
    super.initState();
    homePresenter = new HomePresenter(this);
    
  }
  displayRecord() {
    setState(() {});
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.center;

    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text('Add Event',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _openAddUserDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          FutureBuilder(
            future:homePresenter.getcourseid(), 
            builder: (context,snapshot){
              if(snapshot.hasError)print(snapshot.data);
              var data = snapshot.data;
              return snapshot.hasData
                ? AddUserDialog(context:context, myHomePageState: this, isEdit:false, user:null,dateTime:widget.dateTime,courseid:data)
                : Center(child: CircularProgressIndicator());
            },
          )

    );

    setState(() {});
  }

  List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: _openAddUserDialog,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(leading: BackButton(onPressed:(){Navigator.pop(context);}),
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: new FutureBuilder<List<User>>(
        future: homePresenter.getUser(widget.dateTime),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          
          return snapshot.hasData
              ? new UserList(data,homePresenter,widget.dateTime)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

}
