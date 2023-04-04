#import "PluginHelperPlugin.h"
#include <objc/runtime.h>

@implementation PluginHelperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugin_helper"
            binaryMessenger:[registrar messenger]];
  PluginHelperPlugin* instance = [[PluginHelperPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

@end
