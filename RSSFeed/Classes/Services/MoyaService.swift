//
//  MoyaService.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 3/3/18.
//  Copyright © 2018 Yesbol Kulanbekov. All rights reserved.
//

import Foundation
import Moya


let provider = MoyaProvider<RSSService>()

enum RSSService {
    case search(text:String)
    case loadDefault(url: String)
}


extension RSSService: TargetType {
    var baseURL: URL {
        switch self {
        case .search(_):
            return URL(string: "https://cloud.feedly.com/v3/search/feeds")!
        case .loadDefault(let url):
            return URL(string: url)!
            
        }
    }
    
    var path: String {
        switch self {
        case .search(_):
            return ""
        case .loadDefault(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search(_),.loadDefault(_):
            return .get

        }
    }
    
    
    var task: Task {
        switch self {
        case .search(let text):
            return .requestParameters(parameters: ["query":text], encoding: URLEncoding.queryString)
        case .loadDefault(_):
            return .requestPlain
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let text):
            return ["q": text]
        case .loadDefault(_):
            return nil
        }
    }

    
    var sampleData: Data {
        switch self {
        case .search(_), .loadDefault(_):
            return "Half measures are as bad as nothing at all.".utf8Encoded

        }
    }

    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}


// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
