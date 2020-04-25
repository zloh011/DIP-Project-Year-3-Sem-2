import 'package:dip_taskplanner/constants.dart';
import 'package:flutter/material.dart';
import 'package:dip_taskplanner/homescreen.dart';
import 'package:intl/intl.dart';
class CircularButton extends StatelessWidget {
  CircularButton({this.text, this.function,this.visible,this.location,this.dateTime,this.boxShadowColor});
  final List<int> location;
  final String text;
  final Function function;
  final DateTime dateTime;
  final bool visible; //disappear if false
  final Color boxShadowColor; //BoxShadow Color for the studying week and exam week 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: visible==null ?true :visible,
        child: GestureDetector(
          onTap: () {
            function();
            print(dateTime.toString());
            Navigator.push(context,MaterialPageRoute(builder: (context){return MyHomePage(title:"Hi",dateTime: DateFormat('yyyy-MM-dd').format(dateTime),);}));
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            height: 40.0,
            width: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
              boxShadow: [
                BoxShadow(
                    color: boxShadowColor == null? Colors.grey[900]: boxShadowColor,
                    offset: Offset(2.5, 2.5),
                    spreadRadius: 5.0,
                    blurRadius: 3.0),
              ],
            ),
            child: Text('$text'),
          ),
        ),
      ),
    );
  }
}

