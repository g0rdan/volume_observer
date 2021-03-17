#import "VolumeObserverPlugin.h"
#if __has_include(<volume_observer/volume_observer-Swift.h>)
#import <volume_observer/volume_observer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "volume_observer-Swift.h"
#endif

@implementation VolumeObserverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVolumeObserverPlugin registerWithRegistrar:registrar];
}
@end
