//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mary Elizabeth McManamon on 4/27/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
class RecordedAudio {
/**
    Custom class represents audio file recorded by our app
    - filePathUrl: location of recorded file in our phone's document directory
    - title: recorded file's title
*/
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl :NSURL, title: String) {
        
        self.filePathUrl = filePathUrl
        self.title = title
        
    }
    
}

