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
        
        case flickrPhotosSearch(Double, Double, Int)
        
        var urlString : String {
            switch self {
            case .flickrPhotosSearch(let lat, let lon, let page):
                return "\(EndPoints.base)method=flickr.photos.search&api_key=\(Auth.key)&lat=\(lat)&lon=\(lon)&format=json&nojsoncallback=1&per_page=12&page=\(page)"
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
    
    class func search(lat: Double, lon: Double, page: Int, completion: @escaping (SearchResult?, Error?) -> Void) {
        taskForGetRequest(url: EndPoints.flickrPhotosSearch(lat, lon, page).url, responseType: FlickrSearchResponse.self) { (response, error) in
                if error != nil {
                completion(nil, error)
            }
            
            let searchResult = SearchResult(
                page: response?.photos.page ?? 0,
                pages: response?.photos.pages ?? 0,
                perpage: response?.photos.perpage ?? 0,
                total: Int(response?.photos.total ?? "0")!,
                photos: response?.photos.photo ?? [])
            completion(searchResult, nil)
        }
    }
}


