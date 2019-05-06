//
//  Note.swift
//  notez
//
//  Created by Nabyl Bennouri on 5/6/19.
//  Copyright © 2019 Three14. All rights reserved.
//

import Foundation

class Note {
    var title: String
    var note: String
    var key: String
    
    init(withTitle: String, withNote: String, withKey: String) {
        title = withTitle
        note = withNote
        key = withKey
    }
}
