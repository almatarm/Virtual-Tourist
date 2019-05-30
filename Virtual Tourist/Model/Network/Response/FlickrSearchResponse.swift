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
    
    var url : URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")!
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
