//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 30/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation

class FlickrClient {

    struct Auth {
        static let key = "1a5b2394fcc619675486685535e80049"
        static let secret = "f8d660f43855c974"
    }
    
    enum EndPoints {
        static let base = "https://www.flickr.com/services/rest/?"
        
        case flickrPhotosSearch(Double, Double)
        
        var urlString : String {
            switch self {
            case .flickrPhotosSearch(let lat, let lon):
                return "\(EndPoints.base)method=flickr.photos.search&api_key=\(Auth.key)&lat=\(lat)&lon=\(lon)&format=json&nojsoncallback=1"
            }
        }
        
        var url : URL {
            return URL(string: urlString)!
        }
    }
    
    @discardableResult
    class func taskForGetRequest<ResponseType : Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void ) -> URLSessionTask {
        return WebAPIClient<FlickrErrorResponse>.taskForGetRequest(url: url, responseType: responseType, requestPostProcess: nil, responsePreprocess: responsePreprocess(data:), completion: completion)
    }
    
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        
        WebAPIClient<FlickrErrorResponse>.taskForPostRequest(url: url, responseType: responseType, body: body, requestPostProcess: nil, responsePreprocess: responsePreprocess(data:), completion: completion)
    }
    
    class func responsePreprocess(data: Data?) -> Data? {
        return data
    }
    
    class func search(lat: Double, lon: Double, completion: @escaping ([URL], Error?) -> Void) {
        taskForGetRequest(url: EndPoints.flickrPhotosSearch(lat, lon).url, responseType: FlickrSearchResponse.self) { (response, error) in
            if error != nil {
                completion([], error)
            }
            
            var urls : [URL] = []
            for photo in (response?.photos.photo)! {
                urls.append(photo.url)
            }
            completion(urls, nil)
        }
    }
}

