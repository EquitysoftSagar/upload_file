import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:upload_file/utils/methods.dart';

class FirebaseService {
  // static FirebaseAuth _firebaseAuth;
  // static FirebaseFirestore _firebaseFirestore;
  static FirebaseStorage _firebaseStorage;

  static void init() {
    // _firebaseAuth = FirebaseAuth.instance;
    // _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
  }

  static Future<String> uploadImage(File file,ValueChanged<double> onProgress)async{
    UploadTask _task = _firebaseStorage
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
