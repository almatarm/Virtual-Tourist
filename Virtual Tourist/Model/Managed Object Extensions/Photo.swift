//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 02/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import UIKit

extension Photo {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
    func setImageData(image: UIImage) {
        imageData = image.pngData()
    }
    
    func getImageData() -> UIImage? {
        return imageData == nil ? nil: UIImage(data: imageData!)
    }

    func getDifferentSize(size: PhotoSize) -> URL? {
        if var linkStr = link?.absoluteString {
            return URL(string:linkStr.slice(from: 0, to: linkStr.count - 5) + size.rawValue + ".jpg")
        }
        return nil
    }
    
}
