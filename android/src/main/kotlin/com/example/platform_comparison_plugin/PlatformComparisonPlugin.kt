package com.example.platform_comparison_plugin

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import android.os.Handler
import android.os.Looper

class PlatformComparisonPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "platform_comparison_plugin")
      channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
        "start" -> {

          val id: String? = call.argument("id")

          channel.invokeMethod("processing", null)

          validateIDForResult(id)
          
        } else -> {
          result.notImplemented()
        }
    }
  }

  private fun validateIDForResult(id: String?) {
    //let's mock a delay of 3 seconds on platform side    
    Handler(Looper.getMainLooper()).postDelayed({
        //simulate a validation process on a platform side
        if (id != null && id == "ANDROID") {
            //optionally, if we were into the simplest interop approach,
            // we could pass a result back to the Flutter side 
            // as MethodChannel's result supports dual use:
            //result.success("Android - start() method called")

            channel.invokeMethod("success", null)
        } else {
            channel.invokeMethod("error", null)
        }
    }, 3000)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
