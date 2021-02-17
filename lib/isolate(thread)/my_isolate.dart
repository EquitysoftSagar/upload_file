import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upload_file/main.dart';
import 'package:upload_file/utils/methods.dart';

class MyIsolate {
  static final channelId = '1';
  static final channelName = 'notification';
  static final channelDes = 'description hhah hahah ...';
  static FlutterIsolate flutterIsolate;
  static ReceivePort _receivePort;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static FirebaseStorage firebaseStorage;
  static bool isFinished = false;

  static void uploadFile(String filepath, {ValueChanged<int> progress}) async {
    _receivePort = ReceivePort();
    // flutterIsolate =
    //     await FlutterIsolate.spawn(isolateFunction, {
    //       "port":_receivePort.sendPort,
    //       "filepath":filepath
    //     });
    /*_receivePort.listen((message) {
      print('receive message ===> $message');
      progress(message as int);
      if(message == 100){
        _receivePort.close();
      }
    }).onDone(() {
      print("receive done");
    });*/
  }

  /*static void isolateFunction(Map<String,dynamic> map) async {
    await Firebase.initializeApp();
    File file = File(map["filepath"]);
    firebaseStorage = FirebaseStorage.instance;
    UploadTask _task = firebaseStorage
        .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg')
        .putFile(file);

    _task.snapshotEvents.listen((event) {
      // onProgress((event.bytesTransferred.toInt() / event.totalBytes.toInt()) * 100);
      print("on progress ===> ${(event.bytesTransferred.toInt() / event.totalBytes.toInt()) * 100}");
    },onError: (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
        return;
      }
      print('Error on uploading progress ===> $e');
    });
    try {
      await _task;
      // return _task.snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }else {
        toastError('Error on uploading task');
      }
      return null;
    }
    // await initializeNotification(id: 0);
    // File file = File(map["filepath"]);
    // var _result = await uploadImage(file, (progress)async{
    //   print("upload progress ===> $progress");
    //   SendPort sendPort = map["port"];
    //   sendPort.send(progress.toInt());
    //   await updateNotificationProgress(progress.toInt(),id: 0);
    // });
    // if(_result!= null){
    //   await updateNotificationComplete(id: 0);
    // }else{
    //   await updateNotificationError(id: 0);
    // }
  }*/

  static Future<void> initializeNotification({int id}) async {
    var _androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var _initializeSettings = InitializationSettings(android: _androidSettings);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(_initializeSettings,
        onSelectNotification: (String payLoad) {});

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId, channelName, channelDes,
        importance: Importance.low,
        priority: Priority.low,
        color: Colors.white,
        showProgress: true,
      indeterminate: true
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      'Upload',
      'in progress...',
      platformChannelSpecifics,
    );
  }

  static Future<void> updateNotificationProgress(int progress,{int id}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId, channelName, channelDes,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            color: Colors.white,
            showProgress: true,
            maxProgress: 100,
            progress: progress);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      'Upload',
      'in progress...',
      platformChannelSpecifics,
    );
  }

  static Future<void> updateNotificationComplete({int id}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDes,
      channelShowBadge: false,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      onlyAlertOnce: true,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      'Upload',
      'Complete',
      platformChannelSpecifics,
    );
  }

  static Future<void> updateNotificationError({int id}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDes,
      channelShowBadge: false,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      onlyAlertOnce: true,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      'Upload unsuccessful',
      'Upload unsuccessful due to some error',
      platformChannelSpecifics,
    );
  }

  static Future<String> uploadImage(File file,ValueChanged<double> onProgress)async{
    firebaseStorage = FirebaseStorage.instance;
    UploadTask _task = firebaseStorage
        .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg')
        .putFile(file);

    _task.snapshotEvents.listen((event) {
      onProgress((event.bytesTransferred.toInt() / event.totalBytes.toInt()) * 100);
    },onError: (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
        return;
      }
      print('Error on uploading progress ===> $e');
    });
    try {
      await _task;
      return _task.snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }else {
        toastError('Error on uploading task');
      }
      return null;
    }
  }
}
