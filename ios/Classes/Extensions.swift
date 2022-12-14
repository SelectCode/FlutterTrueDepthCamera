//
//  Extensions.swift
//  Runner
//
//  Created by Jonathan Mengedoht on 17.01.22.
//

import Foundation

extension Float32 {
    var bytes: [UInt8] {
        withUnsafeBytes(of: self, Array.init)
    }
    var data: Data {
        Data(self.bytes)
    }

}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

extension Float64 {
    var bytes: [UInt8] {
        withUnsafeBytes(of: self, Array.init)
    }
    var data: Data {
        Data(self.bytes)
    }

}

extension Int32 {
    var bytes: [UInt8] {
        withUnsafeBytes(of: self, Array.init)
    }
}
