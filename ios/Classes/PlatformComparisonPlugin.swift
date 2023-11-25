import Flutter

public class PlatformComparisonPlugin: NSObject, FlutterPlugin {

    private var channel: FlutterMethodChannel? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "platform_comparison_plugin", 
            binaryMessenger: registrar.messenger())
        let instance = PlatformComparisonPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "start") {

            let arguments = call.arguments as! [String: Any]
            let id = arguments["id"] as? String
            
            self.channel!.invokeMethod("processing", arguments: nil, result: {(r:Any?) -> () in })

            validateIDForResult(id: id)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func validateIDForResult(id: String?) -> Void {
        // let's mock a delay of 3 seconds on platform side   
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            //simulate a validation process on a platform side
            if (id != nil && id == "IOS") {
                // optionally, if we were into the simplest interop approach,
                // we could pass a result back to the Flutter side 
                // as Flutter iOS Embedder's FlutterResult supports dual use:
                //result("iOS: start() method called")
                
                self.channel!.invokeMethod("success", arguments: nil, result: {(r:Any?) -> () in })
            } else {
                self.channel!.invokeMethod("error", arguments: nil, result: {(r:Any?) -> () in })
            }
        }
    }
}