package com.dataly.datalyapp

import android.content.Context
import android.content.res.Configuration
import android.database.CursorWindow
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Here, you can set the cursor window size
        try {
            val field = CursorWindow::class.java.getDeclaredField("sCursorWindowSize")
            field.isAccessible = true
            field.set(null, 100 * 1024 * 1024) // 100MB is the new size
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
