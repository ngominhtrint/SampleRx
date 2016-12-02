//
//  GiphyRepo.swift
//  Spoofy
//
//  Created by TriNgo on 11/24/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum Giphy {
    case search(String, Int)
}

extension Giphy: TargetType {
    
    var baseURL: URL { return URL(string: "http://api.giphy.com/v1/gifs")! }
    var path: String {
        switch self {
        case .search(_, _):
            return "/search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let query, let offset):
            return ["q": query, "api_key": "dc6zaTOxFJmzC", "offset": offset]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            return "\"mp4\": \"http://media0.giphy.com/media/Z1kpfgtHmpWHS/giphy.mp4\"".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        return .request
    }
}
