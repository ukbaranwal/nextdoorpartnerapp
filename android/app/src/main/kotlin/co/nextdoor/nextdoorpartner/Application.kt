package co.nextdoor.nextdoorpartner

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.view.FlutterMain

class Application: FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(registry: PluginRegistry) {
//        registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
    }
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }
}