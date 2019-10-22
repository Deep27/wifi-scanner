package com.example.wifi_scanner

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

class MainThreadResult(private val result: MethodChannel.Result) : MethodChannel.Result {

    private val handler: Handler = Handler(Looper.getMainLooper())

    override fun success(res: Any?) {
        handler.post {
            result.success(res)
        }
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        handler.post {
            result.error(errorCode, errorMessage, errorDetails)
        }
    }

    override fun notImplemented() {
        handler.post {
            result.notImplemented()
        }
    }
}