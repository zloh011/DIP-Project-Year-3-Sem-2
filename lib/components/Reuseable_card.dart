import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  CircularButton({this.text, this.function,this.visible,this.location});
  final List<int> location;
  final String text;
  final Function function;
  final bool visible; //disappear if false
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: visible==null ?true :visible,
        child: GestureDetector(
          onTap: () {
            function();
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            height: 35.0,
            width: 35.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[900],
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

