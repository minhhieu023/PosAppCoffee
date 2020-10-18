package com.example.SPK_Coffee.NotificationHandler

import android.R
import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.RingtoneManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.example.SPK_Coffee.MainActivity


public class NotificationHandler {
    var CHANNEL_ID = "com.example.spkcoffee"

    fun unregisterCustomBroadcastReceiver(broadcastReceiver: BroadcastReceiver?, context: Context) {
        context.unregisterReceiver(broadcastReceiver)
    }

    @SuppressLint("DefaultLocale")
    fun initNotification(context: Context, channelId: String?, contentTitle: String?, contentText: String?, priority: Int, notificationId: Int) {
        //create intent

        //build notification
        val openAppIntent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, notificationId, openAppIntent, PendingIntent.FLAG_CANCEL_CURRENT)
        val builder = NotificationCompat.Builder(context, channelId!!)
                .setSmallIcon(R.drawable.sym_def_app_icon)
                .setContentTitle(contentTitle)
                .setContentText(contentText)
                .setPriority(priority)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
        builder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
        // Create the NotificationChannel, but only on API 26+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name: CharSequence = "com.primas.channel"
            val description = "my description"
            val channel = NotificationChannel(CHANNEL_ID, name, priority)
            channel.description = description
            val notificationManager: NotificationManager = context.getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
            val notificationManagerCompat = NotificationManagerCompat.from(context)
            notificationManagerCompat.notify(notificationId, builder.build())
        } else {
//            createNotificationBelow25(context, contentTitle, contentText, notificationId, pendingIntent, pendingPopup, pendingCancel, priority)
        }
    }
}