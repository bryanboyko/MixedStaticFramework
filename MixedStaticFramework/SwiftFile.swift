//
//  SwiftFile.swift
//  MixedStaticFramework
//
//  Created by Bryan Boyko on 2/14/18.
//  Copyright © 2018 Bryan Boyko. All rights reserved.
//

import Foundation

public class SwiftFile {
    
    public init () {}
    
    public static func describe() {
        
        let objc = ObjCFile()
        objc.describe()
    }
}
