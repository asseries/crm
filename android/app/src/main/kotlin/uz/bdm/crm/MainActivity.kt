package uz.bdm.crm


import android.annotation.SuppressLint
import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.Color
import android.media.MediaMetadataRetriever
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.ContactsContract.*
import android.util.Log
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.NotificationCompat
import androidx.core.database.getIntOrNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.InputStream


class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "asser/channel"
    var pathMain = ""
    private var count = 0


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "openFolder") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    if (!Environment.isExternalStorageManager()) {
                        openFolder()
                    }
                } else {
                    openFolder()
                }
                Toast.makeText(this, pathMain, Toast.LENGTH_LONG).show()
                result.success(pathMain)
            } else
                if (call.method == "showNotification") {
                    var title = call.argument<String>("title")
                    var body = call.argument<String>("body")
                    var updateCurrent = call.argument<Boolean>("updateCurrent")
                    sendNotification(
                        title,
                        body,
                        "",
                        updateCurrent,
                    )

                } else

                    if (call.method == "setFavContact") {
                        val id = call.argument<String>("id")
                        val fav = call.argument<Boolean>("fav")
//                val fav = call.argument<Boolean>("fav")
                        setFavoriteContact(id ?: "", fav ?: false)
                    } else

                        if (call.method == "getAudioDuration") {
                            runOnUiThread {
                                val path = call.argument<String>("path")
                                result.success(getAudioDuration(path ?: ""))
                            }
                        } else

                            if (call.method == "getContacts") {
                                result.let {
                                    val contacts = getContacts()
                                    // hashMapOf("RESULT" to true, "AVATAR" to contacts,
                                    //                            "CREDITS" to user.credits,
                                    //                            "EMAIL" to user.email,
                                    //                            "LAST_ACTIVE" to user.lastActiveAt,
                                    //                            "NAME" to user.name,
                                    //                            "ROLE" to user.role,
                                    //                            "STATUS" to user.status,
                                    //                            "STATUS_MESSAGE" to user.statusMessage).toString()
//                        it.success(contacts.toList())


                                }
                                result.success(getContacts())
                            } else

                                if (call.method == "getContactById") {
                                    val id = call.argument<String>("id")
                                    val fav = getContactById(id ?: "")
                                    result.success(fav)
                                } else {

                                }
        }
    }


    private fun openFolder() {
        val intent =
            Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        activityResultLauncher.launch(intent)
    }

    private val activityResultLauncher: ActivityResultLauncher<Intent> =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            if (it.resultCode == Activity.RESULT_OK) {
                val intent = it.data
                val uri = intent?.data
                val uriPath = uri?.path ?: ""

                var path = ""
                path = if (uriPath.startsWith("/tree/")) {
                    Environment.getExternalStorageDirectory().path + uriPath.substring(5)
                        .replace("primary", "").replace(":".toRegex(), "")
                } else {
                    uriPath.substring(5).replace("primary", "").replace(":".toRegex(), "")
                }
//                tvPath.text = path + "/"
                Log.i("Directory tree:", path)

                pathMain = "$path/"
                Toast.makeText(this, "$path/", Toast.LENGTH_LONG).show()
            }
        }

    private fun sendNotification(
        title: String?,
        body: String?,
        type: String?,
        updateCurrent: Boolean?
    ) {

        val defaultSoundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        var intent = Intent(this, MainActivity::class.java)
        if (type == "news") {
            intent = Intent(this, MainActivity::class.java)
        } else if (type == "rating") {
            intent = Intent(this, MainActivity::class.java)
        } else {
            intent = Intent(this, MainActivity::class.java)
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent.putExtra("type", type)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val channelId = "FlutterX"
        val builder =
            NotificationCompat.Builder(this, channelId)
                .setSmallIcon(R.drawable.logo)
//                .setLargeIcon(BitmapFactory.decodeResource(applicationContext.resources, R.drawable.logo_only))
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setColor(Color.parseColor("#3568D8"))
                .setSound(defaultSoundUri)
                .setSilent(true)
                .setVibrate(longArrayOf(100, 200, 300, 400, 500, 400, 300, 200, 400))
                .setContentIntent(pendingIntent)

        val manager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "FLUTTER channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            manager.createNotificationChannel(channel)
        }
        manager.notify(
            if (updateCurrent == true) 0 else count,
            builder.build()
        )  //agar bir nechta notification kerak bolsa 0 ni o'rniga count qoyiladi
        count++
    }

    @SuppressLint("Range", "Recycle")
    fun getContacts(): ArrayList<Map<String, Any?>> {
        val contentResolver: ContentResolver = contentResolver
        var hashContacts = arrayListOf<Map<String, Any?>>()

        val fieldListProjection = arrayOf(
            CommonDataKinds.Phone.CONTACT_ID,
            CommonDataKinds.Phone.DISPLAY_NAME_PRIMARY,
            CommonDataKinds.Phone.NUMBER,
            CommonDataKinds.Phone.NORMALIZED_NUMBER,
            Contacts.HAS_PHONE_NUMBER,
            Contacts.PHOTO_URI,
            Contacts.STARRED
        )
        val sort = CommonDataKinds.Phone.DISPLAY_NAME_PRIMARY + " ASC"
        val phones = contentResolver
            .query(
                CommonDataKinds.Phone.CONTENT_URI,
                fieldListProjection,
                null,
                null,
                sort
            )
        val normalizedNumbersAlreadyFound = HashSet<String>()

        if (phones != null && phones.count > 0) {
            while (phones.moveToNext()) {
                val normalizedNumber =
                    phones.getString(phones.getColumnIndex(CommonDataKinds.Phone.DISPLAY_NAME))
                if (phones.getString(
                        phones.getColumnIndex(
                            Contacts.HAS_PHONE_NUMBER
                        )
                    ).toInt() > 0
                ) {
                    if (normalizedNumbersAlreadyFound.add(normalizedNumber)) {
                        val id =
                            phones.getInt(phones.getColumnIndex(CommonDataKinds.Phone.CONTACT_ID))
                        val name =
                            phones.getString(phones.getColumnIndex(CommonDataKinds.Phone.DISPLAY_NAME))
                        val phoneNumber =
                            phones.getString(phones.getColumnIndex(CommonDataKinds.Phone.NUMBER))
                        val fav =
                            phones.getInt(phones.getColumnIndex(CommonDataKinds.Phone.STARRED))
                        val isFav: Boolean = fav == 1
                            val contactUri: Uri =
                                ContentUris.withAppendedId(Contacts.CONTENT_URI, id.toLong())

//                        val photoInputStream = Contacts.openContactPhotoInputStream(
//                            contentResolver,
//                            contactUri
//                        )



//                        val photoUri: String? =
//                            phones.getString(phones.getColumnIndex(CommonDataKinds.Phone.PHOTO_URI))
                        hashContacts.add(
                            hashMapOf(
                                "id" to id,
                                "name" to name,
                                "number" to phoneNumber,
                                "favorite" to fav,
//                                "photoUri" to photoInputStream?.readBytes()
                            )
                        )
                    }
                }
            }
            phones.close()
        }
        return hashContacts
    }

    private fun setFavoriteContact(id: String, fav: Boolean) {
        val favInt = if (fav) {
            1
        } else {
            0
        }
        val values = ContentValues()
        values.put(Contacts.STARRED, favInt)
        contentResolver.update(
            Contacts.CONTENT_URI,
            values,
            Contacts._ID + "= ?",
            arrayOf(id)
        )
    }

    @SuppressLint("Range")
    fun getContactById(id: String): Boolean {
//        var fav = 0
//        val cursor= contentResolver.query(
//            CommonDataKinds.Phone.CONTENT_URI,
//            null,
//            CommonDataKinds.Phone.CONTACT_ID + " = ?", arrayOf(id), null
//        )
//        fav = cursor?.getInt(cursor.getColumnIndex(CommonDataKinds.Phone.STARRED))?:0
//        cursor?.close()
//        return fav
        // Build the Uri to query to table
        // Build the Uri to query to table
        val myPhoneUri = Uri.withAppendedPath(
            CommonDataKinds.Phone.CONTENT_URI, id
        )

        // Query the table

        // Query the table
        val phoneCursor = managedQuery(
            myPhoneUri, null, null, null, null
        )
        phoneCursor.moveToFirst()
        while (!phoneCursor.isAfterLast) {
            val starred: Int = phoneCursor.getIntOrNull(
                phoneCursor.getColumnIndexOrThrow(CommonDataKinds.Phone.STARRED)
            ) ?: 0
            return starred != 0
            phoneCursor.moveToNext()
        }
        return false
    }

    fun getAudioDuration(path: String): Int {
        val uri = Uri.parse(path)
        val mmr = MediaMetadataRetriever()
        mmr.setDataSource(this, uri)
        val durationStr = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
        return durationStr?.toIntOrNull() ?: 0
    }
}
