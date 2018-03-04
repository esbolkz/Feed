//
//  FeedParser.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 3/4/18.
//  Copyright © 2018 Yesbol Kulanbekov. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import FeedKit

class FeedFinder {
    static let shared = FeedFinder()
    
    func loadDefaults(success: @escaping (_ feeds: [Feed]) -> Void) {
        provider.request(.search(text: "iOS")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                
                
                print("Status code", statusCode)
                do {
                    let json = try JSON(data: data)
                    let results = json["results"]
                    let feedJSONs: [String] = results.map {
                        let value = $0.1.rawString()
                        return value!
                    }
                    
                    
                    let feedURLs = feedJSONs.map { (feed: String) -> Feed in
                        return Feed(JSONString: feed)!
                    }
                    let defaultFeeds = [feedURLs[0],
                                        feedURLs[1],
                                        feedURLs[2]]
                    
                    success(defaultFeeds)
                    
                    
                    
                } catch {
                    print("json fail")
                }
            case let .failure(error):
                print("Error",error)
            }
        }
    }
    
    func searchFeeds(with text: String, success: @escaping (_ feeds: [Feed]) -> Void) {
        
        provider.request(.search(text: text)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
            
                
                print("Status code", statusCode)
                do {
                    let json = try JSON(data: data)
                    let results = json["results"]
                    let feedJSONs: [String] = results.map {
                        let value = $0.1.rawString()
                        return value!
                    }


                    let feedURLs = feedJSONs.map { (feed: String) -> Feed in
                        return Feed(JSONString: feed)!
                    }
                    
                    success(feedURLs)
                    
                    
                    
                } catch {
                    print("json fail")
                }
            case let .failure(error):
                print("Error",error)
            }
        }
    }
    
}



import ObjectMapper
struct Feed: Mappable {
    var title: String
    var feedId: String
    var feedURL : String {
        let array = feedId.components(separatedBy: "http")
        return "http" + array[1]
    }
    
    init?(map: Map) {
        self.title = ""
        self.feedId = ""
    }
    
    mutating func mapping(map: Map) {
        title   <- map ["title"]
        feedId  <- map ["feedId"]
    }
}





