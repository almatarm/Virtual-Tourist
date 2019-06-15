//
//  FlickerPage.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 11/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation

struct SearchResult {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photos: [URL]
}
