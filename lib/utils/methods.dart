import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo<T>(BuildContext context, Widget widget,
    {ValueChanged<T> result}) {
  if (result != null) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget))
        .then((value) => result(value));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}

void showProgress(BuildContext context /*String title*/) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    )),
  );
}

void toastError(
  String message,
) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.red,
    fontSize: 15,
    // webBgColor: "linear-gradient(to right, #DC1C13, #EA4C46)",
  );
}

void toastSuccess(
  String message,
) {
  Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      fontSize: 15,
      textColor: Colors.white);
}

/*Future<bool> isInternetConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}*/