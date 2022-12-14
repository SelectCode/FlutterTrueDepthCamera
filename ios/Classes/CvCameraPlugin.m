#import "CvCameraPlugin.h"

#if __has_include(<cv_camera/cv_camera-Swift.h>)
#import <cv_camera/cv_camera-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cv_camera-Swift.h"

#endif

@implementation CvCameraPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    [SwiftCvCameraPlugin registerWithRegistrar:registrar];
}
@end
