//
//  CVPixelBuffer+Extensions.swift
//  Runner
//
//  Created by Jonathan Mengedoht on 17.12.21.
//

import Foundation
import CoreVideo
import Accelerate

extension CVPixelBuffer {

    // デプスが16bitで得られていることを前提
    func depthValues() -> [Float32]? {
        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        var pixelData = [Float32](repeating: 0, count: Int(width * height))
        let baseAddress = CVPixelBufferGetBaseAddress(self)
        guard let baseAddress = baseAddress,
              CVPixelBufferGetPixelFormatType(self) == kCVPixelFormatType_DepthFloat16 ||
                      CVPixelBufferGetPixelFormatType(self) == kCVPixelFormatType_DisparityFloat16
        else {
            return nil
        }

        // Float16という型がない（Floatは32bit）ので、UInt16として読み出す
        let data = UnsafeMutableBufferPointer<UInt16>(start: baseAddress.assumingMemoryBound(to: UInt16.self), count: width * height)
        for yMap in 0..<height {
            for index in 0..<width {
                let baseAddressIndex = index + yMap * width
                // UInt16として読みだした値をFloat32に変換する
                var f16Pixel = data[baseAddressIndex]  // Read as UInt16
                var f32Pixel = Float32(0.0)
                var src = vImage_Buffer(data: &f16Pixel, height: 1, width: 1, rowBytes: 2)
                var dst = vImage_Buffer(data: &f32Pixel, height: 1, width: 1, rowBytes: 4)
                vImageConvert_Planar16FtoPlanarF(&src, &dst, 0)

                // Float32の配列に格納
                pixelData[baseAddressIndex] = f32Pixel
            }
        }
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        return pixelData
    }
}
