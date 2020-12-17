//
//  MediaResponse.swift
//  Photo App
//
//  Created by Woojun Park on 2020/12/17.
//

import Foundation

struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let urls: [String : String]
}

