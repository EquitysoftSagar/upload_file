import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:upload_file/firebase/firebase_service.dart';
import 'package:upload_file/pages/home_page.dart';
import 'package:workmanager/workmanager.dart';

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) {
//     print("Native called background task: $task"); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }
File globalFile;
isolateFunction(Map<String, dynamic> map) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  File file = File(map["filepath"]);
  print("start");
  var u = await FirebaseStorage.instance.ref("image/${DateTime.now().millisecondsSinceEpoch}").putFile(file);
  print("finish");
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async{
    if(task == "simpleTask"){
      await Firebase.initializeApp();
      // File file = File(map["filepath"]);
      // await upload(inputData["path"]);
      print("start");
      try{
        /*UploadTask u = FirebaseStorage.instance.ref("image/${DateTime.now().millisecondsSinceEpoch}").putFile(File(inputData["path"]));
        u.snapshotEvents.listen((event) {
          print("on progress ===> ${(event.bytesTransferred.toInt() / event.totalBytes.toInt()) * 100}");
        });*/
        await FirebaseStorage.instance.ref("image/${DateTime.now().millisecondsSinceEpoch}").putFile(File(inputData["path"]));
        print("success");
        Workmanager.cancelAll();
      }catch(e){
        print("error ====> $e");
        Workmanager.cancelAll();
      }
      // Workmanager.cancelAll();
    }
    return Future.value(true);
  });
}
Future<void> upload(File file)async{
  FirebaseStorage.instance.ref("image/${DateTime.now().millisecondsSinceEpoch}").putFile(file).snapshotEvents.listen((event) {
    print("on progress ===> ${(event.bytesTransferred.toInt() / event.totalBytes.toInt()) * 100}");
  });
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager.initialize(callbackDispatcher);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        FirebaseService.init();
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.light(),
            primarySwatch: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
