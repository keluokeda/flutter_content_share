#import "FlutterContentSharePlugin.h"
#import <flutter_content_share/flutter_content_share-Swift.h>

@implementation FlutterContentSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterContentSharePlugin registerWithRegistrar:registrar];
}
@end
