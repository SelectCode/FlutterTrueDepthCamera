//
//  FaceIdData.swift
//  Runner
//
//  Created by Julian Hartl on 22.04.22.
//

import Foundation

struct FaceIdData {
    var XYZ: [[Float32]]
    var RGB: [[UInt8]]
    var depthValues: [Float32]
    var width: Int32
    var height: Int32
}
