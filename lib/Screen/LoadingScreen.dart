import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dip_taskplanner/Screen/CalendarPage.dart';
import 'package:dip_taskplanner/components/regExp.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var datebasehelper = DatabaseHelper();
  String state = 'Loading Files';
  bool exist = false;
  final myTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    existence();
  }
  Future<void> existence () async{
    bool exist = await datebasehelper.coursesExist();
    print(exist);
    setState((){
      if(exist) state = '1';
      else state = '2';
    });
  }
  @override
  Widget build(BuildContext context) {
    return getOption();
  }
  Widget getOption (){
    switch (state) {
      case '1': return CalendarPage();
      case '2': return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('lib/Assets/Sample.jpeg'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0, horizontal: 20.0),
                  child: TextField(controller: myTextController,decoration: InputDecoration(hintText: 'Paste here',labelText:'Print/Check Courses Registered' ) ,),
                ),
                Row(
                  
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(left:16.0),
                      child: FlatButton(onPressed: (){
                        final func = ListOfCourses();
                        if(myTextController.text.isNotEmpty){
                          bool check = func.addToDatabase(myTextController.text,context);
                          if(check){ 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CalendarPage();
                                },
                              ),
                            );
                          }
                          else{
                              showDialog(
                              context: context,
                              builder: (context)=> AlertDialog(
                                title: Text('Error'),
                                content: Text('Please copy and paste your Courses Registered correctly.'),
                                actions: [
                                  FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Okay'))
                                ],
                              ),
                              barrierDismissible: false
                            );
                          }

                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (_)=>
                              AlertDialog(
                                title: Text('Error'),
                                content: Text('Please do not leave it empty and \ncopy-paste your Courses Registered.'),
                                actions: [
                                  FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Okay'))
                                ],
                              ),
                              barrierDismissible: false
                            );
                        }
                      }, 
                      child: Text('Submit'),),
                    ),flex:1),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(right:24.0),
                      child: FlatButton(onPressed: (){myTextController.clear();}, child: Text('Clear'),),
                    ),flex:1),
                  ],
                ),

              ],
            )
            
          
            
          ),
        ),
    ),
      );
        break;
      default: return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(state.toString())
          ],
        ))),
      );break;
    }
  }
}

