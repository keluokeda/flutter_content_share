package com.ke.fluttercontentshare

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.os.Environment
import android.support.v4.content.FileProvider
import com.tbruyelle.rxpermissions2.RxPermissions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import java.io.File
import java.io.FileOutputStream
import java.util.*

class FlutterContentSharePlugin(private val activity: Activity) : MethodCallHandler {

    private val externalFilesDirectory = activity.getExternalFilesDir(Environment.DIRECTORY_PICTURES)

    private val providerName = activity.packageName + ".flutter_content_share"

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "github.com/keluokeda/flutter_content_share")
            channel.setMethodCallHandler(FlutterContentSharePlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "share") {
            val map = call.arguments

            if (map is Map<*, *>) {
                share(map)
            }
        } else {
            result.notImplemented()
        }
    }


    private fun share(map: Map<*, *>) {
        val text = map["text"] as? String

        if (text != null) {
            //分享纯文字
            shareText(text)
            return
        }

        val bytes = map["image"] as? ByteArray

        if (bytes != null) {
            shareImage(bytes)
            return
        }

        val url = map["url"] as? String

        if (url != null) {
            shareText(url)
            return
        }


    }


    private fun shareText(text: String) {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
        }

        activity.startActivity(Intent.createChooser(intent, "分享到："))
    }


    private fun shareImage(byteArray: ByteArray) {
        val rxPermissions = RxPermissions(activity)

        rxPermissions.request(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                .filter { it }
                .observeOn(Schedulers.io())
                .map {
                    val imageFile = createTemporaryWritableImageFile()
                    val fileStream = FileOutputStream(imageFile)
                    fileStream.write(byteArray, 0, byteArray.size)
                    fileStream.flush()
                    fileStream.close()
                    return@map FileProvider.getUriForFile(activity, providerName, imageFile)
                }
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe {
                    val intent = Intent(Intent.ACTION_SEND).apply {
                        type = "image/*"
                        putExtra(Intent.EXTRA_STREAM, it)
                    }
                    activity.startActivity(Intent.createChooser(intent, "分享到："))
                }
    }


    private fun createTemporaryWritableImageFile(): File {
        val filename = UUID.randomUUID().toString()

        return File.createTempFile(filename, ".png", externalFilesDirectory)
    }
}
