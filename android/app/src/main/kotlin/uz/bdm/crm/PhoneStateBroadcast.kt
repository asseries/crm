package uz.bdm.crm

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.widget.Toast


class PhoneStateBroadcast : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val telephony = context.getSystemService(Service.TELEPHONY_SERVICE) as TelephonyManager
        telephony.listen(object : PhoneStateListener() {
            @Deprecated("Deprecated in Java")
            override fun onCallStateChanged(state: Int, incomingNumber: String) {
                super.onCallStateChanged(state, incomingNumber)
                println("incomingNumber : $incomingNumber")
                Toast.makeText(
                    context, "TeleDuce Customer $incomingNumber",
                    Toast.LENGTH_LONG
                ).show()
            }
        }, PhoneStateListener.LISTEN_CALL_STATE)
    }
}