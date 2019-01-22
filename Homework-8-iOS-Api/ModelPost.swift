//
//  ModelPost.swift
//  Homework-8-iOS-Api
//
//  Created by Alla on 1/18/19.
//  Copyright © 2019 AndreiSavchenko. All rights reserved.
//

import Foundation

struct ModelPost: Decodable {
    let data: Data
}

struct Data: Decodable {
    let id: String
}
