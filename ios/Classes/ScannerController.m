//
//  ScannerController.m
//  Runner
//
//  Created by Julian Hartl on 04.04.22.
//

#import <Foundation/Foundation.h>
#import "ScannerController.h"

@implementation ScannerControllerUtils

+ (NSMutableDictionary *)convertSampleBufferToNativeImage:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Must lock base address before accessing the pixel data
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);

    size_t imageWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t imageHeight = CVPixelBufferGetHeight(pixelBuffer);

    NSMutableArray *planes = [NSMutableArray array];

    const Boolean isPlanar = CVPixelBufferIsPlanar(pixelBuffer);
    size_t planeCount;
    if (isPlanar) {
        planeCount = CVPixelBufferGetPlaneCount(pixelBuffer);
    } else {
        planeCount = 1;
    }

    for (int i = 0; i < planeCount; i++) {
        void *planeAddress;
        size_t bytesPerRow;
        size_t height;
        size_t width;

        if (isPlanar) {
            planeAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, i);
            bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, i);
            height = CVPixelBufferGetHeightOfPlane(pixelBuffer, i);
            width = CVPixelBufferGetWidthOfPlane(pixelBuffer, i);
        } else {
            planeAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
            bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
            height = CVPixelBufferGetHeight(pixelBuffer);
            width = CVPixelBufferGetWidth(pixelBuffer);
        }

        NSNumber *length = @(bytesPerRow * height);
        NSData *bytes = [NSData dataWithBytes:planeAddress length:length.unsignedIntegerValue];

        NSMutableDictionary *planeBuffer = [NSMutableDictionary dictionary];
        planeBuffer[@"bytesPerRow"] = @(bytesPerRow);
        planeBuffer[@"width"] = @(width);
        planeBuffer[@"height"] = @(height);
        planeBuffer[@"bytes"] = bytes;

        [planes addObject:planeBuffer];
    }
    // Lock the base address before accessing pixel data, and unlock it afterwards.
    // Done accessing the `pixelBuffer` at this point.
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);

    NSMutableDictionary *imageBuffer = [NSMutableDictionary dictionary];
    imageBuffer[@"width"] = [NSNumber numberWithUnsignedLong:imageWidth];
    imageBuffer[@"height"] = [NSNumber numberWithUnsignedLong:imageHeight];
    imageBuffer[@"planes"] = planes;

    return imageBuffer;

}

@end
