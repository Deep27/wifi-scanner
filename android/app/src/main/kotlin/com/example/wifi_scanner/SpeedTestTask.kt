package com.example.wifi_scanner

import android.os.AsyncTask
import android.util.Log
import fr.bmartel.speedtest.SpeedTestReport
import fr.bmartel.speedtest.SpeedTestSocket
import fr.bmartel.speedtest.inter.ISpeedTestListener
import fr.bmartel.speedtest.model.SpeedTestError
import java.math.BigDecimal
import java.math.RoundingMode


class SpeedTestTask(val result: MainThreadResult) : AsyncTask<Void, Void, String>() {

    private val TAG = "SpeedTestTask"

    override fun doInBackground(vararg params: Void?): String? {
        val speedTestSocket = SpeedTestSocket()
        speedTestSocket.addSpeedTestListener(object : ISpeedTestListener {
            override fun onCompletion(report: SpeedTestReport?) {
                val kbps = formatKbps(report!!.transferRateBit)
                val mbps = formatMbps(report.transferRateBit)
                val kBps = formatKBps(report.transferRateOctet)
                val mBps = formatMBps(report.transferRateOctet)
                Log.i(TAG, "[COMPLETED] rate in kbps: $kbps")
                Log.i(TAG, "[COMPLETED] rate in mbps: $mbps")
                Log.i(TAG, "[COMPLETED] rate in kBps: $kBps")
                Log.i(TAG, "[COMPLETED] rate in mBps: $mBps")
                result.success(hashMapOf(
                        "kilobits" to kbps,
                        "megabits" to mbps,
                        "kilobytes" to kBps,
                        "megabytes" to mBps
                ))
            }

            override fun onProgress(percent: Float, report: SpeedTestReport?) {
                Log.i(TAG, "[PROGRESS]: $percent%")
            }

            override fun onError(speedTestError: SpeedTestError?, errorMessage: String?) {
                result.error("Error.", "An error occured while testing network speed", null)
            }
        })
        speedTestSocket.startDownload("http://ipv4.ikoula.testdebit.info/10M.iso")
        return null
    }

    private fun formatKbps(bits: BigDecimal): Double {
        return bits.divide(BigDecimal(1000)).setScale(2, RoundingMode.HALF_DOWN).toDouble()
    }

    private fun formatMbps(bits: BigDecimal): Double {
        return bits.divide(BigDecimal(1000_000)).setScale(2, RoundingMode.HALF_DOWN).toDouble()
    }

    private fun formatKBps(bytes: BigDecimal): Double {
        return bytes.divide(BigDecimal(1000)).setScale(2, RoundingMode.HALF_DOWN).toDouble()
    }

    private fun formatMBps(bytes: BigDecimal): Double {
        return bytes.divide(BigDecimal(1000_000)).setScale(2, RoundingMode.HALF_DOWN).toDouble()
    }
}