import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

const String academicCal =
    'https://www.ntu.edu.sg/sasd/oas/AcademicCalendar/Documents/NTU';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool downloading = false;
  String progressString = 'No Data';

  @override
  void initState() {
    int yearNow = DateTime.now().month > 6
        ? ( DateTime.now().year+ 1)
        : DateTime.now().year;
    // TODO: POP UP A Translucent Screen of input text bar and button
    // TODO: IF Academic Not Downloaded
    super.initState();
    downloadFile(
        "$academicCal%20Academic%20Calendar_AY${yearNow.toString()}-${(yearNow % 100+1).toString()}%20(Semester).pdf");
  }

  Future<void> downloadFile(String downloadLink) async {
    final int semNow = DateTime.now().month < 6 ? 1 : 2;
    final int yearNow = DateTime.now().month < 6
        ? (DateTime.now().year)
        : (DateTime.now().year+1);

//    WidgetsFlutterBinding.ensureInitialized();
    Dio dio = Dio();
//    await FlutterDownloader.initialize();
    var dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/$yearNow-${(yearNow % 100).toString()}';
    if (io.File(path).existsSync() != true) {
      try {
        print('${dir.path}/Assets/$yearNow-${(yearNow % 100).toString()}.pdf');
        await dio.download(
          downloadLink,
          '${dir.path}/Assets/$yearNow-${(yearNow % 100).toString()}.pdf',
          onReceiveProgress: (rec, total) {
            print('Rec:$rec,Total: $total');
            setState(() {
              downloading = true;
              progressString = ((rec/total)*100).toStringAsFixed(0)+'%';
            });
          },
        );
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = false;
        progressString = 'Completed';
      });
    }
  }

  @override
  void deactivate() {
    // TODO: Create Enum of Courses with the corresponding tutorial classes dates
    super.deactivate();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: downloading
            ? Container(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Downloading File: $progressString'),
                    ],
                  ),
                ),
              )
            : Text('$progressString'),
      ),
    );
  }
}

//https://www.ntu.edu.sg/sasd/oas/AcademicCalendar/Documents/NTU%20Academic%20Calendar_AY2019-20%20(Semester).pdf

//DecoratedBox(
//    decoration: BoxDecoration(
//      image: DecorationImage(image: AssetImage("your_asset"), fit: BoxFit.cover),
//    ),
//    child: Center(child: FlutterLogo(size: 300)),
//  );
