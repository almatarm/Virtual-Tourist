//
//  FlickrSearchResponse.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 30/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable{
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    func url(size: PhotoSize = .thumbnail) -> URL {
        return  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg")!
    }
}

struct FlickrPage: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickrPhoto]
}

struct FlickrSearchResponse: Codable {
    let photos: FlickrPage
    let stat: String
}

enum PhotoSize : String {
    case small_square = "s" //  small square 75x75
    case large_square = "q"  //  large square 150x150
    case thumbnail = "t"  //  thumbnail, 100 on longest side
    case small = "m"  //  small, 240 on longest side
    case medium_500 = "n"  //  medium, 500 on longest side
    case meidum_800 = "z"   // medium 800, 800 on longest side†
    case large_1024 = "b"   // large, 1024 on longest side*
    case large_1600 = "h"  //  large 1600, 1600 on longest side†
    case large_2048 = "k"  //  large 2048, 2048 on longest side†
}
