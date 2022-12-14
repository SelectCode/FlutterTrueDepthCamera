//
//  ScannerController.h
//  Runner
//
//  Created by Julian Hartl on 04.04.22.
//

@import AVFoundation;
@import Foundation;
@import Flutter;


#ifndef ScannerController_h
#define ScScannerControllerUtils


@interface ScannerControllerUtils : NSObject

+ (NSMutableDictionary *)convertSampleBufferToNativeImage:(CMSampleBufferRef)sampleBuffer;


@end

#endif /* ScannerController_h */
