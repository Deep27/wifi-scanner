package com.example.wifi_scanner

import android.net.wifi.ScanResult

class MyScanResult {
    companion object {
        fun mapResults(results: List<ScanResult>): List<Map<String, Any>> {
            val resultsToSave = mutableListOf<Map<String, Any>>()

            results.forEach { scanResult ->
                resultsToSave.add(resultToMapObject(scanResult))
            }

            return resultsToSave
        }

        private fun resultToMapObject(scanResult: ScanResult): HashMap<String, Any> {
            return hashMapOf(
                    "SSID" to scanResult.SSID,
                    "BSSID" to scanResult.BSSID,
                    "level" to scanResult.level,
                    "frequency" to scanResult.frequency,
                    "channelWidth" to scanResult.channelWidth,
                    "timestamp" to scanResult.timestamp
            )
        }
    }
}