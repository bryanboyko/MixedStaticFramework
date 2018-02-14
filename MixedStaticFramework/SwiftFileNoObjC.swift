//
//  SwiftFileNoObjC.swift
//  MixedStaticFramework
//
//  Created by Bryan Boyko on 2/14/18.
//  Copyright © 2018 Bryan Boyko. All rights reserved.
//

import Foundation

public class SwiftFileNoObjC {
    
    public init () {}
    
    public static func describe() {
        SwiftFile.describe()
        print("This is a swift file from the static framework that does not import any objc")
    }
}
