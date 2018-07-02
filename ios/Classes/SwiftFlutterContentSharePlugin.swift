import Flutter
import UIKit
    
public class SwiftFlutterContentSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "github.com/keluokeda/flutter_content_share", binaryMessenger: registrar.messenger())
    
    let instance = SwiftFlutterContentSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    result("iOS " + UIDevice.current.systemVersion)
    
    if call.method == "share" {
        share(arguments: call.arguments)
    }
    
   
    
  }
    

    private func share(arguments:Any?){
        let map = arguments as? Dictionary<String,Any?>
        
        if map == nil {
            return
        }
        
        var activityItems = [Any]()
        
        if let text = map!["text"] as? String{
            activityItems.append(text)
        }
        
        if let imageData = map!["image"] as? FlutterStandardTypedData{
            
            
            let image = UIImage(data: imageData.data)
            
            activityItems.append(image!)
        }
        
        if let url = map!["url"] as?String{
            activityItems.append(url)
        }
        
        let shareController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController;
        
        rootViewController?.present(shareController, animated: false, completion: nil)
    }
}
