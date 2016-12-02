//
//  GiphyDataModel.swift
//  Spoofy
//
//  Created by TriNgo on 11/25/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import Foundation
import Mapper

struct GiphyDataModel: Mappable {
    let url: String?
    let type: String?
    let images: Images?
    
    init(map: Mapper) throws {
        try url = map.from("url")
        try type = map.from("type")
        try images = map.from("images") as Images
    }
}

struct Images: Mappable {
    let original: Original?
    
    init(map: Mapper) throws {
        try original = map.from("original") as Original
    }
}

struct Original: Mappable {
    let mp4: String?
    let url: String?
    
    init(map: Mapper) throws {
        try mp4 = map.from("mp4")
        try url = map.from("url")
    }
}
