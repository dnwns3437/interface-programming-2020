//
//  MediaResponse.swift
//  UnsplashPhotos
//
//  Created by Woojun Park on 2020/12/18.
//

import Foundation

struct MediaResponse: Codable {
    var results : [Photo]
}

struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let urls: [String : String]
    var liked_by_user: Bool 

}
