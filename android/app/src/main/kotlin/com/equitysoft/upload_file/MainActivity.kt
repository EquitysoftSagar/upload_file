package com.equitysoft.upload_file

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.CountDownTimer
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {
    private val channel = "flutter.native/helper"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "upload_notification") {
            // code of method upload notification
            try {
                val filePath:String = call.argument<String>("file_path")!!
                Log.e("file path from native", filePath)
               val uploadServiceIntent = Intent(this,MyService::class.java)
                       .putExtra("file_path",filePath)
                startService(uploadServiceIntent)
                result.success("success")
            } catch (e: Exception) {
                result.error("0", "Error on create notification", "")
            }
        }
    }

}
