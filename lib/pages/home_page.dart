import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_file/firebase/firebase_service.dart';
import 'package:upload_file/isolate(thread)/my_isolate.dart';
import 'package:upload_file/main.dart';
import 'package:upload_file/utils/methods.dart';
import 'package:workmanager/workmanager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final channelId = '1';
  final channelName = 'notification';
  final channelDes = 'description hhah hahah ...';
  static final platform = MethodChannel("flutter.native/helper");
  List<String> _filePathList = [];
  bool _intermediate = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // _initializeNotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        print('App is in  pause');
        break;
      case AppLifecycleState.resumed:
        print('App is in  resume');
        break;
      case AppLifecycleState.inactive:
        print('App is in  inactive');
        break;
      case AppLifecycleState.detached:
        print('App is in  detached');
        break;
      default:
        break;
    }
  }

  void _initializeNotification() {
    var _androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var _iosSettings = IOSInitializationSettings();
    var _initializeSettings =
    InitializationSettings(android: _androidSettings, iOS: _iosSettings);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(_initializeSettings,
        onSelectNotification: (String payLoad) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _filesListView(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _filesListView() =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.insert_drive_file,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
            title: Text(_filePathList[index]
                .split('/')
                .last),
            onTap: () {},
          );
        },
        itemCount: _filePathList.length,
      );

  Widget _bottomNavigationBar() =>
      Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: _onUploadFileTap,
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Upload File'))),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: _showUploadNotification,
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Call Notification'))),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: _onAddFileTap,
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Add File'))),
          ],
        ),
      );
   Future<void> initializeNotification() async {
    var _androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var _initializeSettings = InitializationSettings(android: _androidSettings);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(_initializeSettings,
        onSelectNotification: (String payLoad) {});

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId, channelName, channelDes,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        color: Colors.white,
        showProgress: true,
        indeterminate: true
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Upload',
      'in progress...',
      platformChannelSpecifics,
    );
  }

  void _onUploadFileTap() async {
    if (_filePathList.length != 0) {
      /*await FlutterIsolate.spawn(isolateFunction, {
              "filepath":_filePathList[0]
            });*/
     await platform.invokeMethod("upload_notification",{
       "file_path":_filePathList[0]
     });
    }
  }

  void _onAddFileTap() async {
    var _result =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (_result != null) {
      setState(() {
        globalFile = File(_result.path);
        _filePathList.add(_result.path);
      });
    }
  }

  Future<void> _showUploadNotification() async {

    // var _androidChannelSpecifics = AndroidNotificationDetails(
    //     channelId, channelName, channelDes,
    //     showProgress: true,
    //     indeterminate: true,
    //     // maxProgress: 100,
    //     // progress:_progress,
    //     color: Colors.white,
    //     importance: Importance.high,
    //     priority: Priority.high);
    //
    // var _channelSpecifics = NotificationDetails(
    //   android: _androidChannelSpecifics,);
    //
    // await flutterLocalNotificationsPlugin.show(
    //     0, 'Uploading', 'Image', _channelSpecifics,
    //     payload: 'Custom sound');
  }

  Widget _isolateBottomNavigationBar() =>
      Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: () async{

                    },
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Start isolate'))),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Pause isolate'))),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: FlatButton(
                    onPressed: () {
                    },
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text('Kill isolate'))),
          ],
        ),
      );
}