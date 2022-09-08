#import "FlutterStreamPagingPlugin.h"
#if __has_include(<flutter_stream_paging/flutter_stream_paging-Swift.h>)
#import <flutter_stream_paging/flutter_stream_paging-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_stream_paging-Swift.h"
#endif

@implementation FlutterStreamPagingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterStreamPagingPlugin registerWithRegistrar:registrar];
}
@end
