package com.example.SPK_Coffee

import android.os.Bundle
import android.os.PersistableBundle
import com.example.SPK_Coffee.NotificationHandler.NotificationHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    var notificationHandler = NotificationHandler();
    var CHANNEL_ID = "com.example.spkcoffee";
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

    }
    var CHANNEL = "com.spkcoffee/notification";
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method.equals("createNotification")) {
                var title = call.argument<String>("title");
                var content = call.argument<String>("content");
                notificationHandler.initNotification(context,CHANNEL_ID,title,content,4,1);
                result.success("OK");
            } else  {
                result.notImplemented();
            }
        }
    }
}
