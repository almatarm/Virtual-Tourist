//
//  FlickrErrorResponse.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 30/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation

struct FlickrErrorResponse: Codable {
    let state: String
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case state = "stat"
        case statusCode = "code"
        case statusMessage = "message"
    }
}

extension FlickrErrorResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
