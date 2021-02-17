package com.equitysoft.upload_file

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.OnPausedListener
import com.google.firebase.storage.UploadTask
import java.io.File
import java.io.FileInputStream
import java.lang.Exception


class MyService : Service() {
    private var notificationChannel:NotificationChannel? = null
    private var notificationManager:NotificationManager? = null
    private var builder:NotificationCompat.Builder? = null
    private val channelId = "0"
    private val channelName = "channel"
    private val storage: FirebaseStorage = FirebaseStorage.getInstance()
    private var filePath:String = ""

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

       try {
            createNotification(NotificationManager.IMPORTANCE_HIGH,0,true)
            filePath = intent!!.getStringExtra("file_path")!!
            val file = File(filePath)
            val progress = file.length().toInt()

            Log.e("Service", "Service Start")
            Log.e("file length ", "$progress")

            val stream = FileInputStream(File(filePath))
            val storageRef = storage.reference.child("images/${System.currentTimeMillis()}.jpg")
            val uploadTask = storageRef.putStream(stream)

            uploadTask.addOnProgressListener { taskSnapshot ->
                builder = NotificationCompat.Builder(this, channelId)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle("My notification")
                        .setContentText("Uploading...")
                        .setColor(resources.getColor(R.color.white))
                        .setProgress(progress,taskSnapshot.bytesTransferred.toInt(),false)

//                builder!!.priority = NotificationCompat.PRIORITY_LOW
//                builder!!.setProgress(progress, taskSnapshot.bytesTransferred.toInt(), false)
//                        .setContentText("Uploading...")
                notificationManager!!.notify(0, builder!!.build())
                Log.e("progress", "$progress")
                Log.e("cal**********", "${taskSnapshot.bytesTransferred} / ${taskSnapshot.totalByteCount}")

            }.addOnSuccessListener {
                stopSelf()
                Log.e("stop itself","")
            }

           return START_STICKY
        }catch (e:Exception){
           return START_NOT_STICKY
       }
    }

    override fun onDestroy() {
        builder!!.setContentText("Uploaded completed")
                .setProgress(0,0,false)
        notificationManager!!.notify(0, builder!!.build())
        Log.e("Service","Service Destroy")
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    private fun createNotification(importance:Int,progress:Int,indeterminate:Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = NotificationChannel(channelId, channelName, importance)
             notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager!!.createNotificationChannel(notificationChannel!!) //create notification channel
        }

        builder = NotificationCompat.Builder(this, channelId)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("My notification")
                .setContentText("Hello World!")
                .setOnlyAlertOnce(true)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setColor(resources.getColor(R.color.white))
                .setProgress(100,progress,indeterminate)

        notificationManager!!.notify(0, builder!!.build())
    }
    private fun uploadFile(){

    }
}