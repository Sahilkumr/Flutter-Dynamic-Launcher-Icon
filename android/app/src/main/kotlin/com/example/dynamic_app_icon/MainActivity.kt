package com.example.dynamic_app_icon

import android.app.Activity
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
 override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "my_channel").setMethodCallHandler { call, result ->
            if (call.method == "getCurrentActivityName") {
                val activityName = getCurrentActivityName()
                result.success(activityName)
            
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCurrentActivityName(): String? {
        val activity: Activity = this
        return activity.localClassName
    }
}
