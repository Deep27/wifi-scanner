package com.example.wifi_scanner

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "scanner/scan"
    private lateinit var wifiManager: WifiManager
    private lateinit var scanResults: List<ScanResult>
    private lateinit var ssids: List<String>

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
                scanResults = wifiManager.scanResults
                ssids = wifiManager.scanResults.map { it.SSID }
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
                scanResults = wifiManager.scanResults
                ssids = wifiManager.scanResults.map { it.SSID }
                result.success(ssids)
            } else {
                result.notImplemented()
            }
        }
    }
}
