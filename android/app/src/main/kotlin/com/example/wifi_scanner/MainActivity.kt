package com.example.wifi_scanner

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val TAG = "MainActivity"
    private val CHANNEL = "network/wifi"
    private lateinit var wifiManager: WifiManager
    private lateinit var scanResults: List<Map<String, Any>>

    private val wifiScanReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val success = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                intent!!.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
            } else {
                false
                // VERSION.SDK_INT < M
            }
            if (success) {
                val scanned = wifiManager.startScan()
                scanResults = MyScanResult.mapResults(wifiManager.scanResults)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

        val intentFilter = IntentFilter()
        intentFilter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
        applicationContext.registerReceiver(wifiScanReceiver, intentFilter)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scan") {
                wifiManager.startScan()
                scanResults = MyScanResult.mapResults(wifiManager.scanResults)
                Log.i(TAG, "Networks found: ${wifiManager.scanResults.size}")
                wifiManager.scanResults.forEachIndexed { i, r -> Log.i(TAG, "$i:\t$r") }
                result.success(scanResults)
            } else if (call.method == "speedtest") {
                val speedtestTask = SpeedTestTask(MainThreadResult(result))
                speedtestTask.execute()
            } else {
                result.notImplemented()
            }
        }
    }
}
