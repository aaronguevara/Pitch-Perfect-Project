//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Aaron Guevara on 3/12/15.
//  Copyright (c) 2015 Quetzal Group LLC. All rights reserved.
//

import Foundation

//class to store recorded audio obejct and file path URL so we can transfer this vaule between views.
class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title:String!
    init(filePathValue: NSURL, titleValue: String) {
        self.filePathURL = filePathValue
        self.title = titleValue
    }
}
