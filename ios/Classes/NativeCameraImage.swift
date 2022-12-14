//
//  NativeCameraImage.swift
//  Runner
//
//  Created by Julian Hartl on 06.04.22.
//

import Foundation

struct Plane {
    var width: Int
    var height: Int
    var bytes: [UInt8]
    var bytesPerRow: Int
}

struct NativeCameraImage {
    var planes: [Plane]
    var height: Int
    var width: Int
}
