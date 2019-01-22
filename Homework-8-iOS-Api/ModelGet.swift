//
//  ModelGet.swift
//  Homework-8-iOS-Api
//
//  Created by Alla on 1/20/19.
//  Copyright © 2019 AndreiSavchenko. All rights reserved.
//

import Foundation

struct ModelGet: Decodable {
    let data: DataGet
}
struct DataGet: Decodable {
    let images: Images
}
struct Images: Decodable {
    let original_mp4: OriginalMp4
}
struct OriginalMp4: Decodable {
    let mp4: String
}
