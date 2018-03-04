//
//  ServerError.swift
//  RSSFeed
//
//  Created by Yesbol Kulanbekov on 3/3/18.
//  Copyright © 2018 Yesbol Kulanbekov. All rights reserved.
//

import Foundation

enum ServerError: Error {
    case authentication(message: String)
    case badRequest(message: String)
    case notFound(message: String)
    case serverError(message: String)
    case unknownError(message: String)
    case noCode(message: String)
}
