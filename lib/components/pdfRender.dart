import 'package:pdf_render/pdf_render.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
//WILL BE Fixed soon 

class RenderPdf {

  bool downloading = false;
  String progressString = 'No Data';
  int yearNow = DateTime.now().month < 6
      ? (DateTime.now().year - 1)
      : (DateTime.now().year);
  Future<PdfPageImage> pdfRenderer(io.Directory dir) async {
//    var dir = await getApplicationDocumentsDirectory();
    PdfDocument doc = await PdfDocument.openFile(
        '${dir.path}/Assets/$yearNow-${(yearNow % 100 + 1).toString()}.pdf');
    PdfPage page = await doc.getPage(1);
    PdfPageImage pageImage = await page.render();
    doc.dispose();
    return pageImage;
  }
  Future<void> getPDF(String downloadLink) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/$yearNow-${(yearNow % 100 + 1).toString()}';
    if (io.File(path).existsSync() != true) {
      try {
        print(
            '${dir.path}/Assets/$yearNow-${(yearNow % 100 + 1).toString()}.pdf');
        await dio.download(
          downloadLink,
          '${dir.path}/Assets/$yearNow-${(yearNow % 100 + 1).toString()}.pdf',
          onReceiveProgress: (rec, total) {
            print('Rec:$rec,Total: $total');
            setState(() {
              progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
              downloading = true;
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
      PdfPageImage academicCalendar = await pdfRenderer(dir);

//       showDialog(
//         context: (context),
//         builder: (BuildContext context) => Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           elevation: 0.0,
//           child: Column(
//             children: <Widget>[
//               TextField(
//                 onChanged: (val){
                  
//                 },
//                 decoration:
//                     InputDecoration(hintText: 'Print/Check Courses Registered'),
//               ),
//               SizedBox(
//                 width: 10.0,
//               ),
//               FlatButton(
//                 onPressed: () {
// //                        buttonPressed = true;
//                   print('ButtonPressed');
                  
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) {
//                   //       return CalendarPage(academicCalendar: academicCalendar);
//                   //     },
//                   //   ),
//                   // );
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       );
    }
  }

  void setState(Null Function() param0) {}

  /*Codes inside Component Folder
      downloadPDF is to download the specific file to the application document
     */
  //getPDF("$urlAcadCal%20Academic%20Calendar_AY${yearNow.toString()}-${(yearNow % 100 + 1).toString()}%20(Semester).pdf");

}
//https://www.ntu.edu.sg/sasd/oas/AcademicCalendar/Documents/NTU%20Academic%20Calendar_AY2019-20%20(Semester).pdf

//DecoratedBox(
//    decoration: BoxDecoration(
//      image: DecorationImage(image: AssetImage("your_asset"), fit: BoxFit.cover),
//    ),
//    child: Center(child: FlutterLogo(size: 300)),
//  );
/*downloading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Downloading File: $progressString',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : Text('$progressString'),
              */