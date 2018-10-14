//
//  ApiList.swift
//  assignment
//
//  Created by Chandan on 14/10/18.
//  Copyright © 2018 Chandan. All rights reserved.
//

import Foundation

class ApiList {
    private static let base = "http://www.omdbapi.com/"
    
    static func getSearches(text: String, page: Int, handler: @escaping Handler<DataModel>) {
        let params: [String: Any] = ["s": text, "page": page, "apikey": "eeefc96f"]
        ApiManager.GET(url: base, params: params, handler: handler)
    }
}
